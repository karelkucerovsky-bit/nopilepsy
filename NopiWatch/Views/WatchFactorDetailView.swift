import SwiftUI
import NopiCore

struct WatchFactorDetailView: View {
    let factor: FactorContribution

    private var citation: ResearchCitation? {
        Citations.all.first { $0.factorCategory == factor.category }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                // Header
                Label(factor.category.displayName, systemImage: factor.category.iconName)
                    .font(.headline)

                // Current value
                HStack {
                    Text("Current")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(factor.displayValue)
                        .font(.body.bold())
                }

                // Baseline (if available)
                if let baseline = factor.baselineValue {
                    HStack {
                        Text("Baseline")
                            .foregroundStyle(.secondary)
                        Spacer()
                        Text(String(format: "%.1f", baseline))
                            .font(.body)
                    }
                }

                // Score
                HStack {
                    Text("Risk Score")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(String(format: "%.0f%%", factor.blendedScore * 100))
                        .font(.body.bold())
                        .foregroundStyle(scoreColor)
                }

                Divider()

                // Citation
                if let citation {
                    Text(citation.authors)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    Text(citation.journal + ", \(citation.year)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle("Detail")
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
