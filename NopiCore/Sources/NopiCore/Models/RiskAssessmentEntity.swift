import Foundation
import SwiftData

@Model
public final class RiskAssessmentEntity {
    @Attribute(.unique) public var id: UUID
    public var timestamp: Date
    public var levelRaw: String
    public var score: Double
    public var confidence: Double
    public var modelVersion: String
    public var baselineCalibrated: Bool

    @Relationship(deleteRule: .cascade, inverse: \FactorContributionEntity.assessment)
    public var factors: [FactorContributionEntity]

    public var level: RiskLevel {
        get { RiskLevel(rawValue: levelRaw) ?? .low }
        set { levelRaw = newValue.rawValue }
    }

    public init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        level: RiskLevel,
        score: Double,
        confidence: Double,
        modelVersion: String = "1.0.0",
        baselineCalibrated: Bool = false,
        factors: [FactorContributionEntity] = []
    ) {
        self.id = id
        self.timestamp = timestamp
        self.levelRaw = level.rawValue
        self.score = score
        self.confidence = confidence
        self.modelVersion = modelVersion
        self.baselineCalibrated = baselineCalibrated
        self.factors = factors
    }

    public convenience init(from assessment: RiskAssessment) {
        self.init(
            id: assessment.id,
            timestamp: assessment.timestamp,
            level: assessment.level,
            score: assessment.score,
            confidence: assessment.confidence,
            modelVersion: assessment.modelVersion,
            baselineCalibrated: assessment.baselineCalibrated
        )
    }
}
