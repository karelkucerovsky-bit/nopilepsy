import Foundation

public struct SleepStages: Sendable, Codable {
    public let deepMinutes: Double
    public let coreMinutes: Double
    public let remMinutes: Double
    public let awakeMinutes: Double

    public var totalAsleepMinutes: Double {
        deepMinutes + coreMinutes + remMinutes
    }

    public var totalMinutes: Double {
        totalAsleepMinutes + awakeMinutes
    }

    public var deepPercent: Double {
        guard totalAsleepMinutes > 0 else { return 0 }
        return (deepMinutes / totalAsleepMinutes) * 100
    }

    public var remPercent: Double {
        guard totalAsleepMinutes > 0 else { return 0 }
        return (remMinutes / totalAsleepMinutes) * 100
    }

    public init(deepMinutes: Double, coreMinutes: Double, remMinutes: Double, awakeMinutes: Double) {
        self.deepMinutes = deepMinutes
        self.coreMinutes = coreMinutes
        self.remMinutes = remMinutes
        self.awakeMinutes = awakeMinutes
    }
}

public struct SleepData: Sendable {
    public let totalDurationHours: Double
    public let stages: SleepStages?
    public let startDate: Date
    public let endDate: Date

    public init(totalDurationHours: Double, stages: SleepStages?, startDate: Date, endDate: Date) {
        self.totalDurationHours = totalDurationHours
        self.stages = stages
        self.startDate = startDate
        self.endDate = endDate
    }
}
