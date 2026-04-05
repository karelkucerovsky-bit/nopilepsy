import Foundation

public struct CalibrationProgress: Sendable {
    public let daysCollected: Int
    public let minimumDays: Int
    public let confidence: Double
    public let metricsReady: [FactorCategory: Bool]

    public var isCalibrated: Bool {
        daysCollected >= minimumDays
    }

    public var progress: Double {
        min(Double(daysCollected) / Double(minimumDays), 1.0)
    }

    public var blendRatio: Double {
        guard daysCollected >= 14 else { return 0 }
        return min(Double(daysCollected - 14) / 14.0, 1.0) * 0.6
    }

    public init(
        daysCollected: Int = 0,
        minimumDays: Int = 14,
        confidence: Double = 0,
        metricsReady: [FactorCategory: Bool] = [:]
    ) {
        self.daysCollected = daysCollected
        self.minimumDays = minimumDays
        self.confidence = confidence
        self.metricsReady = metricsReady
    }
}
