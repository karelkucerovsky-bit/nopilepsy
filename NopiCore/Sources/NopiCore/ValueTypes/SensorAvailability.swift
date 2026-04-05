import Foundation

public struct SensorAvailability: Sendable, Codable {
    public var sleepTracking: Bool
    public var hrv: Bool
    public var restingHeartRate: Bool
    public var spO2: Bool
    public var skinTemperature: Bool
    public var stepCount: Bool
    public var ecg: Bool

    public var availableCount: Int {
        [sleepTracking, hrv, restingHeartRate, spO2, skinTemperature, stepCount, ecg]
            .filter { $0 }.count
    }

    public var totalCount: Int { 7 }

    public var availabilityRatio: Double {
        Double(availableCount) / Double(totalCount)
    }

    public init(
        sleepTracking: Bool = false,
        hrv: Bool = false,
        restingHeartRate: Bool = false,
        spO2: Bool = false,
        skinTemperature: Bool = false,
        stepCount: Bool = false,
        ecg: Bool = false
    ) {
        self.sleepTracking = sleepTracking
        self.hrv = hrv
        self.restingHeartRate = restingHeartRate
        self.spO2 = spO2
        self.skinTemperature = skinTemperature
        self.stepCount = stepCount
        self.ecg = ecg
    }

    public static var allAvailable: SensorAvailability {
        SensorAvailability(
            sleepTracking: true, hrv: true, restingHeartRate: true,
            spO2: true, skinTemperature: true, stepCount: true, ecg: true
        )
    }
}
