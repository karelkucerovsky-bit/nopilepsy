import Foundation

public struct MedicationSchedule: Sendable, Codable {
    public let name: String
    public let dosageMg: Double
    public let timesPerDay: Int
    public let scheduledTimes: [DateComponents]
    public let isActive: Bool

    public init(
        name: String,
        dosageMg: Double,
        timesPerDay: Int,
        scheduledTimes: [DateComponents],
        isActive: Bool = true
    ) {
        self.name = name
        self.dosageMg = dosageMg
        self.timesPerDay = timesPerDay
        self.scheduledTimes = scheduledTimes
        self.isActive = isActive
    }
}

public struct MedicationDoseRecord: Sendable {
    public let timestamp: Date
    public let taken: Bool
    public let notes: String?

    public init(timestamp: Date, taken: Bool, notes: String? = nil) {
        self.timestamp = timestamp
        self.taken = taken
        self.notes = notes
    }
}
