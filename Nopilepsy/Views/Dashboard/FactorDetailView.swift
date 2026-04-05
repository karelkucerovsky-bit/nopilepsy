import SwiftUI
import SwiftData
import Charts
import NopiCore

struct FactorDetailView: View {
    let factor: FactorContribution

    @Query private var assessments: [RiskAssessmentEntity]

    private var citation: ResearchCitation? {
        Citations.all.first { $0.factorCategory == factor.category }
    }

    private var historicalData: [(date: Date, value: Double)] {
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        return assessments
            .filter { $0.timestamp >= thirtyDaysAgo }
            .sorted { $0.timestamp < $1.timestamp }
            .compactMap { assessment in
                guard let f = assessment.factors.first(where: { $0.categoryRaw == factor.category.rawValue }),
                      let val = f.rawValue else { return nil }
                return (date: assessment.timestamp, value: val)
            }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    Image(systemName: factor.category.iconName)
                        .font(.title)
                        .foregroundStyle(scoreColor)
                    VStack(alignment: .leading) {
                        Text(factor.category.displayName)
                            .font(.title2.bold())
                        Text(factor.displayValue)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    RiskLevelBadge(level: RiskLevel.from(score: factor.blendedScore * 100))
                }

                Divider()

                // Scores
                VStack(spacing: 12) {
                    ScoreRow(label: "Threshold Score", value: factor.thresholdScore)
                    if let deviation = factor.deviationScore {
                        ScoreRow(label: "Deviation Score", value: deviation)
                    }
                    ScoreRow(label: "Blended Score", value: factor.blendedScore, isBold: true)
                    ScoreRow(label: "Weight", value: factor.weight)
                }

                // Baseline
                if let baseline = factor.baselineValue {
                    VStack(alignment: .leading, spacing: 8) {
                        SectionHeaderView(title: "Personal Baseline")
                        HStack {
                            Text("Your average")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Text(String(format: "%.1f %@", baseline, factor.category.unit))
                        }
                    }
                }

                // 30-day sparkline
                if !historicalData.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        SectionHeaderView(title: "30-Day Trend")
                        SparklineView(data: historicalData, color: scoreColor)
                            .frame(height: 120)
                    }
                }

                Divider()

                // Citation
                if let citation {
                    VStack(alignment: .leading, spacing: 8) {
                        SectionHeaderView(title: "Research Basis")

                        Text(citation.studyTitle)
                            .font(.subheadline.weight(.medium))

                        Text(citation.authors)
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text("\(citation.journal), \(citation.year)")
                            .font(.caption)
                            .foregroundStyle(.secondary)

                        Text(citation.findingSummary)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.top, 4)

                        if let url = citation.doiURL {
                            Link("View Study (DOI)", destination: url)
                                .font(.caption)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(factor.category.displayName)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var scoreColor: Color {
        switch factor.blendedScore {
        case ..<0.25: .green
        case 0.25..<0.5: .yellow
        case 0.5..<0.75: .orange
        default: .red
        }
    }
}

private struct ScoreRow: View {
    let label: String
    let value: Double
    var isBold: Bool = false

    var body: some View {
        HStack {
            Text(label)
                .font(isBold ? .subheadline.bold() : .subheadline)
                .foregroundStyle(isBold ? .primary : .secondary)
            Spacer()
            Text(String(format: "%.0f%%", value * 100))
                .font(isBold ? .subheadline.bold() : .subheadline)
        }
    }
}
