import Foundation

public struct ResearchCitation: Sendable, Identifiable {
    public let id: UUID
    public let factorCategory: FactorCategory
    public let studyTitle: String
    public let authors: String
    public let journal: String
    public let year: Int
    public let doi: String
    public let findingSummary: String

    public var formattedCitation: String {
        "\(authors) (\(year)). \(studyTitle). \(journal)."
    }

    public var doiURL: URL? {
        URL(string: "https://doi.org/\(doi)")
    }

    public init(
        id: UUID = UUID(),
        factorCategory: FactorCategory,
        studyTitle: String,
        authors: String,
        journal: String,
        year: Int,
        doi: String,
        findingSummary: String
    ) {
        self.id = id
        self.factorCategory = factorCategory
        self.studyTitle = studyTitle
        self.authors = authors
        self.journal = journal
        self.year = year
        self.doi = doi
        self.findingSummary = findingSummary
    }
}
