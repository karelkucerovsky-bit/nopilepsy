import Foundation
import SwiftData
import NopiCore

@Observable
final class HistoryViewModel {
    enum TimeRange: String, CaseIterable {
        case day = "Day"
        case week = "Week"
        case month = "Month"
    }

    var selectedRange: TimeRange = .week

    var startDate: Date {
        let calendar = Calendar.current
        switch selectedRange {
        case .day: return calendar.date(byAdding: .day, value: -1, to: Date())!
        case .week: return calendar.date(byAdding: .day, value: -7, to: Date())!
        case .month: return calendar.date(byAdding: .month, value: -1, to: Date())!
        }
    }

    func filterAssessments(_ assessments: [RiskAssessmentEntity]) -> [RiskAssessmentEntity] {
        assessments
            .filter { $0.timestamp >= startDate }
            .sorted { $0.timestamp < $1.timestamp }
    }

    func chartData(from assessments: [RiskAssessmentEntity]) -> [(date: Date, score: Double)] {
        filterAssessments(assessments).map { (date: $0.timestamp, score: $0.score) }
    }

    func averageScore(from assessments: [RiskAssessmentEntity]) -> Double? {
        let filtered = filterAssessments(assessments)
        guard !filtered.isEmpty else { return nil }
        return filtered.map(\.score).reduce(0, +) / Double(filtered.count)
    }

    func maxScore(from assessments: [RiskAssessmentEntity]) -> Double? {
        filterAssessments(assessments).map(\.score).max()
    }

    func assessmentCount(from assessments: [RiskAssessmentEntity]) -> Int {
        filterAssessments(assessments).count
    }
}
