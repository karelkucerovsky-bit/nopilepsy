import Foundation

public struct MetricBaseline: Sendable, Codable {
    public var ema: Double
    public var emVariance: Double
    public var sampleCount: Int
    public var lastUpdated: Date

    public var standardDeviation: Double {
        sqrt(max(emVariance, 0))
    }

    public var isReady: Bool {
        sampleCount >= 14
    }

    public init(ema: Double = 0, emVariance: Double = 0, sampleCount: Int = 0, lastUpdated: Date = Date()) {
        self.ema = ema
        self.emVariance = emVariance
        self.sampleCount = sampleCount
        self.lastUpdated = lastUpdated
    }
}

public struct BaselineModel: Sendable {
    public let metrics: [FactorCategory: MetricBaseline]
    public let calibrationProgress: CalibrationProgress

    public init(metrics: [FactorCategory: MetricBaseline], calibrationProgress: CalibrationProgress) {
        self.metrics = metrics
        self.calibrationProgress = calibrationProgress
    }
}
