import Foundation

public struct HealthSnapshot: Sendable {
    public let timestamp: Date
    public let sleepDurationHours: Double?
    public let sleepStages: SleepStages?
    public let hrvMs: Double?
    public let restingHeartRate: Double?
    public let spO2Percent: Double?
    public let skinTempCelsius: Double?
    public let activitySteps: Int?
    public let ecgClassification: String?
    public let sensorAvailability: SensorAvailability

    public init(
        timestamp: Date = Date(),
        sleepDurationHours: Double? = nil,
        sleepStages: SleepStages? = nil,
        hrvMs: Double? = nil,
        restingHeartRate: Double? = nil,
        spO2Percent: Double? = nil,
        skinTempCelsius: Double? = nil,
        activitySteps: Int? = nil,
        ecgClassification: String? = nil,
        sensorAvailability: SensorAvailability = SensorAvailability()
    ) {
        self.timestamp = timestamp
        self.sleepDurationHours = sleepDurationHours
        self.sleepStages = sleepStages
        self.hrvMs = hrvMs
        self.restingHeartRate = restingHeartRate
        self.spO2Percent = spO2Percent
        self.skinTempCelsius = skinTempCelsius
        self.activitySteps = activitySteps
        self.ecgClassification = ecgClassification
        self.sensorAvailability = sensorAvailability
    }
}
