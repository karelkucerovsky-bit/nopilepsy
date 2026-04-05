import Foundation

public struct RiskAssessment: Sendable {
    public let id: UUID
    public let timestamp: Date
    public let level: RiskLevel
    public let score: Double
    public let confidence: Double
    public let factors: [FactorContribution]
    public let baselineCalibrated: Bool
    public let modelVersion: String

    public init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        level: RiskLevel,
        score: Double,
        confidence: Double,
        factors: [FactorContribution],
        baselineCalibrated: Bool,
        modelVersion: String = "1.0.0"
    ) {
        self.id = id
        self.timestamp = timestamp
        self.level = level
        self.score = score
        self.confidence = confidence
        self.factors = factors
        self.baselineCalibrated = baselineCalibrated
        self.modelVersion = modelVersion
    }
}
