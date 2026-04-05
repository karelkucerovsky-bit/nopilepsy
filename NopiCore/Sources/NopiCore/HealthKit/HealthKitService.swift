import Foundation
import HealthKit

public final class HealthKitService: HealthDataProviding, @unchecked Sendable {
    private let store = HKHealthStore()

    public init() {}

    public func requestAuthorization() async throws {
        guard HKHealthStore.isHealthDataAvailable() else {
            throw HealthKitError.notAvailable
        }
        try await store.requestAuthorization(toShare: [], read: HealthKitTypes.readTypes)
    }

    public func fetchLatestSnapshot() async throws -> HealthSnapshot {
        async let sleep = fetchSleep()
        async let hrv = fetchLatestQuantity(.heartRateVariabilitySDNN, unit: .secondUnit(with: .milli))
        async let rhr = fetchLatestQuantity(.restingHeartRate, unit: HKUnit.count().unitDivided(by: .minute()))
        async let spo2 = fetchLatestSpO2()
        async let temp = fetchSleepingTemp()
        async let steps = fetchTodaySteps()

        let sleepData = try? await sleep
        let hrvVal = try? await hrv
        let rhrVal = try? await rhr
        let spo2Val = try? await spo2
        let tempVal = try? await temp
        let stepsVal = try? await steps

        return HealthSnapshot(
            timestamp: Date(),
            sleepDurationHours: sleepData?.totalDurationHours,
            sleepStages: sleepData?.stages,
            hrvMs: hrvVal,
            restingHeartRate: rhrVal,
            spO2Percent: spo2Val,
            skinTempCelsius: tempVal,
            activitySteps: stepsVal,
            sensorAvailability: getSensorAvailability()
        )
    }

    public func getSensorAvailability() -> SensorAvailability {
        SensorAvailability(
            sleepTracking: isAuthorized(HKCategoryType(.sleepAnalysis)),
            hrv: isAuthorized(HKQuantityType(.heartRateVariabilitySDNN)),
            restingHeartRate: isAuthorized(HKQuantityType(.restingHeartRate)),
            spO2: isAuthorized(HKQuantityType(.oxygenSaturation)),
            skinTemperature: isAuthorized(HKQuantityType(.appleSleepingWristTemperature)),
            stepCount: isAuthorized(HKQuantityType(.stepCount)),
            ecg: isAuthorized(HKObjectType.electrocardiogramType())
        )
    }

    public func enableBackgroundDelivery() async throws {
        for type in HealthKitTypes.backgroundDeliveryTypes {
            guard let objectType = type as? HKObjectType else { continue }
            let frequency: HKUpdateFrequency = objectType is HKCategoryType ? .hourly : .immediate
            try await store.enableBackgroundDelivery(for: objectType, frequency: frequency)
        }
    }

    // MARK: - Private Queries

    private func isAuthorized(_ type: HKObjectType) -> Bool {
        store.authorizationStatus(for: type) == .sharingAuthorized ||
        store.authorizationStatus(for: type) != .sharingDenied
    }

    private func fetchLatestQuantity(_ identifier: HKQuantityTypeIdentifier, unit: HKUnit) async throws -> Double? {
        let type = HKQuantityType(identifier)
        let descriptor = HKSampleQueryDescriptor(
            predicates: [.quantitySample(type: type)],
            sortDescriptors: [SortDescriptor(\.startDate, order: .reverse)],
            limit: 1
        )
        let results = try await descriptor.result(for: store)
        return results.first?.quantity.doubleValue(for: unit)
    }

    private func fetchLatestSpO2() async throws -> Double? {
        guard let raw = try await fetchLatestQuantity(.oxygenSaturation, unit: .percent()) else { return nil }
        return raw * 100  // HealthKit stores as 0-1, we want 0-100
    }

    private func fetchSleepingTemp() async throws -> Double? {
        try await fetchLatestQuantity(.appleSleepingWristTemperature, unit: .degreeCelsius())
    }

    private func fetchSleep() async throws -> SleepData? {
        let type = HKCategoryType(.sleepAnalysis)
        let now = Date()
        let yesterday = Calendar.current.date(byAdding: .hour, value: -24, to: now)!
        let predicate = HKQuery.predicateForSamples(withStart: yesterday, end: now)

        let descriptor = HKSampleQueryDescriptor(
            predicates: [.categorySample(type: type, predicate: predicate)],
            sortDescriptors: [SortDescriptor(\.startDate, order: .forward)]
        )
        let samples = try await descriptor.result(for: store)

        guard !samples.isEmpty else { return nil }

        var deepMin = 0.0, coreMin = 0.0, remMin = 0.0, awakeMin = 0.0
        var earliest = Date.distantFuture
        var latest = Date.distantPast

        for sample in samples {
            let duration = sample.endDate.timeIntervalSince(sample.startDate) / 60.0
            if sample.startDate < earliest { earliest = sample.startDate }
            if sample.endDate > latest { latest = sample.endDate }

            switch HKCategoryValueSleepAnalysis(rawValue: sample.value) {
            case .asleepDeep: deepMin += duration
            case .asleepCore: coreMin += duration
            case .asleepREM: remMin += duration
            case .awake, .inBed: awakeMin += duration
            default: break
            }
        }

        let totalAsleep = deepMin + coreMin + remMin
        let stages = SleepStages(
            deepMinutes: deepMin,
            coreMinutes: coreMin,
            remMinutes: remMin,
            awakeMinutes: awakeMin
        )

        return SleepData(
            totalDurationHours: totalAsleep / 60.0,
            stages: stages,
            startDate: earliest,
            endDate: latest
        )
    }

    private func fetchTodaySteps() async throws -> Int? {
        let type = HKQuantityType(.stepCount)
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: type,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, stats, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                let sum = stats?.sumQuantity()?.doubleValue(for: .count())
                continuation.resume(returning: sum.map(Int.init))
            }
            store.execute(query)
        }
    }
}
