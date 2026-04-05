import SwiftUI
import NopiCore

struct AssessmentDetailView: View {
    let assessment: RiskAssessmentEntity

    private var sortedFactors: [FactorContributionEntity] {
        assessment.factors.sorted { $0.weightedContribution > $1.weightedContribution }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text("\(Int(assessment.score))")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(assessment.level.color)

                    RiskLevelBadge(level: assessment.level)

                    Text(NopiFormatters.dateTimeFormatter.string(from: assessment.timestamp))
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 4) {
                        Image(systemName: "sensor.fill")
                            .font(.caption2)
                        Text("\(Int(assessment.confidence * 100))% confidence")
                            .font(.caption2)
                    }
                    .foregroundStyle(.tertiary)
                }
                .padding(.top)

                Divider()

                // Factor breakdown
                VStack(alignment: .leading, spacing: 12) {
                    SectionHeaderView(title: "Factor Breakdown")

                    ForEach(sortedFactors, id: \.id) { factor in
                        HStack(spacing: 12) {
                            if let category = factor.category {
                                Image(systemName: category.iconName)
                                    .foregroundStyle(factorColor(factor.blendedScore))
                                    .frame(width: 24)
                            }

                            VStack(alignment: .leading, spacing: 3) {
                                Text(factor.displayName)
                                    .font(.subheadline.weight(.medium))

                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        Capsule().fill(.gray.opacity(0.15)).frame(height: 6)
                                        Capsule()
                                            .fill(factorColor(factor.blendedScore))
                                            .frame(width: max(geo.size.width * factor.blendedScore, 4), height: 6)
                                    }
                                }
                                .frame(height: 6)
                            }

                            VStack(alignment: .trailing) {
                                Text(String(format: "%.0f%%", factor.blendedScore * 100))
                                    .font(.caption.bold())
                                if let raw = factor.rawValue {
                                    Text(String(format: "%.1f", raw))
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .frame(width: 50)
                        }
                    }
                }
                .padding(.horizontal)

                // Metadata
                VStack(alignment: .leading, spacing: 6) {
                    SectionHeaderView(title: "Details")
                    DetailRow(label: "Model Version", value: assessment.modelVersion)
                    DetailRow(label: "Baseline Calibrated", value: assessment.baselineCalibrated ? "Yes" : "No")
                    DetailRow(label: "Factors Evaluated", value: "\(assessment.factors.count)")
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Assessment")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func factorColor(_ score: Double) -> Color {
        switch score {
        case ..<0.25: .green
        case 0.25..<0.5: .yellow
        case 0.5..<0.75: .orange
        default: .red
        }
    }
}

private struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.caption)
        }
    }
}
