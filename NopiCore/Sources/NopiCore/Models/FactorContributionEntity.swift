import Foundation
import SwiftData

@Model
public final class FactorContributionEntity {
    @Attribute(.unique) public var id: UUID
    public var factorId: String
    public var displayName: String
    public var categoryRaw: String
    public var rawValue: Double?
    public var baselineValue: Double?
    public var thresholdScore: Double
    public var deviationScore: Double?
    public var blendedScore: Double
    public var weightedContribution: Double
    public var weight: Double
    public var citationDOI: String

    public var assessment: RiskAssessmentEntity?

    public var category: FactorCategory? {
        FactorCategory(rawValue: categoryRaw)
    }

    public init(
        id: UUID = UUID(),
        factorId: String,
        displayName: String,
        categoryRaw: String,
        rawValue: Double? = nil,
        baselineValue: Double? = nil,
        thresholdScore: Double,
        deviationScore: Double? = nil,
        blendedScore: Double,
        weightedContribution: Double,
        weight: Double,
        citationDOI: String
    ) {
        self.id = id
        self.factorId = factorId
        self.displayName = displayName
        self.categoryRaw = categoryRaw
        self.rawValue = rawValue
        self.baselineValue = baselineValue
        self.thresholdScore = thresholdScore
        self.deviationScore = deviationScore
        self.blendedScore = blendedScore
        self.weightedContribution = weightedContribution
        self.weight = weight
        self.citationDOI = citationDOI
    }

    public convenience init(from contribution: FactorContribution) {
        self.init(
            id: contribution.id,
            factorId: contribution.category.rawValue,
            displayName: contribution.category.displayName,
            categoryRaw: contribution.category.rawValue,
            rawValue: contribution.rawValue,
            baselineValue: contribution.baselineValue,
            thresholdScore: contribution.thresholdScore,
            deviationScore: contribution.deviationScore,
            blendedScore: contribution.blendedScore,
            weightedContribution: contribution.weightedContribution,
            weight: contribution.weight,
            citationDOI: contribution.citationDOI
        )
    }
}
