import Foundation
import SwiftData

public final class BaselineManager: BaselineLearning, @unchecked Sendable {
    private let alpha: Double = 0.1
    private var metrics: [FactorCategory: MetricBaseline] = [:]
    private var daysCollected: Int = 0
    private var lastUpdateDate: Date?
    private let modelContext: ModelContext

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
        loadFromStore()
    }

    public func getBaseline() -> BaselineModel? {
        guard !metrics.isEmpty else { return nil }
        return BaselineModel(
            metrics: metrics,
            calibrationProgress: getCalibrationProgress()
        )
    }

    public func getCalibrationProgress() -> CalibrationProgress {
        let ready: [FactorCategory: Bool] = Dictionary(
            uniqueKeysWithValues: FactorCategory.allCases.map { cat in
                (cat, metrics[cat]?.isReady ?? false)
            }
        )
        let readyCount = ready.values.filter { $0 }.count
        let confidence = Double(readyCount) / Double(FactorCategory.allCases.count)

        return CalibrationProgress(
            daysCollected: daysCollected,
            minimumDays: 14,
            confidence: confidence,
            metricsReady: ready
        )
    }

    public func updateBaseline(with snapshot: HealthSnapshot) {
        updateMetric(.sleepDuration, value: snapshot.sleepDurationHours)
        updateMetric(.sleepQuality, value: snapshot.sleepStages?.deepPercent)
        updateMetric(.hrv, value: snapshot.hrvMs)
        updateMetric(.restingHeartRate, value: snapshot.restingHeartRate)
        updateMetric(.spO2, value: snapshot.spO2Percent)
        updateMetric(.skinTemperature, value: snapshot.skinTempCelsius)
        updateMetric(.activityLevel, value: snapshot.activitySteps.map(Double.init))

        // Track unique days
        let calendar = Calendar.current
        if let lastDate = lastUpdateDate {
            if !calendar.isDate(lastDate, inSameDayAs: snapshot.timestamp) {
                daysCollected += 1
            }
        } else {
            daysCollected = 1
        }
        lastUpdateDate = snapshot.timestamp

        saveToStore()
    }

    public func reset() {
        metrics = [:]
        daysCollected = 0
        lastUpdateDate = nil
        deleteFromStore()
    }

    private func updateMetric(_ category: FactorCategory, value: Double?) {
        guard let val = value else { return }

        var baseline = metrics[category] ?? MetricBaseline()
        let delta = val - baseline.ema

        if baseline.sampleCount == 0 {
            // First sample — initialize directly
            baseline.ema = val
            baseline.emVariance = 0
        } else {
            baseline.ema += alpha * delta
            baseline.emVariance = (1.0 - alpha) * (baseline.emVariance + alpha * delta * delta)
        }

        baseline.sampleCount += 1
        baseline.lastUpdated = Date()
        metrics[category] = baseline
    }

    // MARK: - Persistence

    private func loadFromStore() {
        let descriptor = FetchDescriptor<BaselineModelEntity>()
        guard let entity = try? modelContext.fetch(descriptor).first else { return }

        daysCollected = entity.daysCollected
        lastUpdateDate = entity.lastUpdated

        if let decoded = try? JSONDecoder().decode([String: MetricBaseline].self, from: entity.metricsJSON) {
            metrics = Dictionary(uniqueKeysWithValues: decoded.compactMap { key, value in
                guard let category = FactorCategory(rawValue: key) else { return nil }
                return (category, value)
            })
        }
    }

    private func saveToStore() {
        let descriptor = FetchDescriptor<BaselineModelEntity>()
        let entity: BaselineModelEntity

        if let existing = try? modelContext.fetch(descriptor).first {
            entity = existing
        } else {
            entity = BaselineModelEntity()
            modelContext.insert(entity)
        }

        entity.daysCollected = daysCollected
        entity.lastUpdated = Date()

        let encodable = Dictionary(uniqueKeysWithValues: metrics.map { ($0.key.rawValue, $0.value) })
        entity.metricsJSON = (try? JSONEncoder().encode(encodable)) ?? Data()

        try? modelContext.save()
    }

    private func deleteFromStore() {
        let descriptor = FetchDescriptor<BaselineModelEntity>()
        if let entities = try? modelContext.fetch(descriptor) {
            for entity in entities {
                modelContext.delete(entity)
            }
            try? modelContext.save()
        }
    }
}
