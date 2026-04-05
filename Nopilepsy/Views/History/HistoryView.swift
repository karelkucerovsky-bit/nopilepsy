import SwiftUI
import SwiftData
import Charts
import NopiCore

struct HistoryView: View {
    @Query(sort: \RiskAssessmentEntity.timestamp, order: .reverse)
    private var allAssessments: [RiskAssessmentEntity]
    @State private var viewModel = HistoryViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Time range picker
                Picker("Range", selection: $viewModel.selectedRange) {
                    ForEach(HistoryViewModel.TimeRange.allCases, id: \.self) { range in
                        Text(range.rawValue).tag(range)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                if allAssessments.isEmpty {
                    EmptyStateView(
                        icon: "chart.xyaxis.line",
                        title: "No History Yet",
                        message: "Risk assessments will appear here as data is collected from your Apple Watch."
                    )
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Trend chart
                            RiskTrendChart(data: viewModel.chartData(from: allAssessments))
                                .frame(height: 200)
                                .padding(.horizontal)

                            // Stats
                            HStack(spacing: 20) {
                                StatCard(
                                    title: "Average",
                                    value: viewModel.averageScore(from: allAssessments).map { String(format: "%.0f", $0) } ?? "—",
                                    icon: "chart.bar"
                                )
                                StatCard(
                                    title: "Peak",
                                    value: viewModel.maxScore(from: allAssessments).map { String(format: "%.0f", $0) } ?? "—",
                                    icon: "arrow.up"
                                )
                                StatCard(
                                    title: "Count",
                                    value: "\(viewModel.assessmentCount(from: allAssessments))",
                                    icon: "number"
                                )
                            }
                            .padding(.horizontal)

                            // Assessment list
                            AssessmentListView(
                                assessments: viewModel.filterAssessments(allAssessments)
                            )
                        }
                    }
                }
            }
            .navigationTitle("History")
        }
    }
}

private struct StatCard: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.title3.bold())
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}
