import SwiftUI
import SwiftData
import NopiCore

struct WatchDashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = WatchDashboardViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    // Risk Circle
                    WatchRiskCircleView(
                        score: viewModel.currentAssessment?.score ?? 0,
                        level: viewModel.currentAssessment?.level ?? .low,
                        confidence: viewModel.currentAssessment?.confidence ?? 0
                    )
                    .frame(height: 120)

                    // Calibration banner
                    if let progress = viewModel.calibrationProgress, !progress.isCalibrated {
                        NavigationLink(destination: WatchCalibrationView(progress: progress)) {
                            HStack {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                Text("Day \(progress.daysCollected) of \(progress.minimumDays)")
                                    .font(.caption2)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.blue.opacity(0.2))
                            .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                    }

                    // Top factors
                    if let factors = viewModel.currentAssessment?.factors.prefix(3), !factors.isEmpty {
                        NavigationLink(destination: WatchFactorListView(
                            factors: Array(viewModel.currentAssessment?.factors ?? [])
                        )) {
                            VStack(spacing: 6) {
                                ForEach(Array(factors)) { factor in
                                    WatchFactorRow(factor: factor)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                    }

                    // Medication quick action
                    if viewModel.hasMedications {
                        NavigationLink(destination: WatchMedicationView()) {
                            Label("Medication", systemImage: "pills.fill")
                                .font(.caption)
                        }
                    }

                    // Last updated
                    if let updated = viewModel.lastUpdated {
                        Text(NopiFormatters.relativeString(from: updated))
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Nopilepsy")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            viewModel.setup(modelContext: modelContext)
            await viewModel.requestPermissions()
            await viewModel.refreshRisk()
        }
    }
}
