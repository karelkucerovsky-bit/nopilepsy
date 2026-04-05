import SwiftUI
import SwiftData
import NopiCore

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = DashboardViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Risk circle
                    RiskCircleView(
                        score: viewModel.currentAssessment?.score ?? 0,
                        level: viewModel.currentAssessment?.level ?? .low,
                        confidence: viewModel.currentAssessment?.confidence ?? 0
                    )
                    .frame(height: 220)
                    .padding(.top)

                    // Calibration banner
                    if let progress = viewModel.calibrationProgress, !progress.isCalibrated {
                        CalibrationBanner(progress: progress)
                    }

                    // Factor breakdown
                    if let factors = viewModel.currentAssessment?.factors, !factors.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeaderView(
                                title: "Contributing Factors",
                                subtitle: "Sorted by impact"
                            )

                            FactorBarChart(factors: factors)
                                .frame(height: CGFloat(factors.count) * 44)

                            ForEach(factors) { factor in
                                NavigationLink(destination: FactorDetailView(factor: factor)) {
                                    FactorRowView(factor: factor)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    } else if !viewModel.isLoading {
                        EmptyStateView(
                            icon: "waveform.path.ecg",
                            title: "No Data Yet",
                            message: "Wear your Apple Watch to start collecting health data. Risk assessment will begin automatically."
                        )
                        .frame(height: 200)
                    }

                    // Last updated
                    if let updated = viewModel.lastUpdated {
                        Text("Updated \(NopiFormatters.relativeString(from: updated))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.bottom)
                    }
                }
            }
            .navigationTitle("Nopilepsy")
            .refreshable {
                await viewModel.refreshRisk(modelContext: modelContext)
            }
            .overlay {
                if viewModel.isLoading && viewModel.currentAssessment == nil {
                    ProgressView("Analyzing health data...")
                }
            }
        }
        .task {
            viewModel.setup(modelContext: modelContext)
            await viewModel.requestPermissions()
            await viewModel.refreshRisk(modelContext: modelContext)
        }
    }
}
