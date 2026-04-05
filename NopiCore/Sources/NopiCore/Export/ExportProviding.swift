import Foundation

public protocol ExportProviding: Sendable {
    func generateCSV(from assessments: [RiskAssessmentEntity]) -> String
}
