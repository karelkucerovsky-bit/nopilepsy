import Foundation

public struct RiskFactor: Sendable, Identifiable {
    public let id: UUID
    public let category: FactorCategory
    public let baseWeight: Double
    public let citation: ResearchCitation

    public init(
        id: UUID = UUID(),
        category: FactorCategory,
        baseWeight: Double,
        citation: ResearchCitation
    ) {
        self.id = id
        self.category = category
        self.baseWeight = baseWeight
        self.citation = citation
    }
}
