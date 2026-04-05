import SwiftUI
import NopiCore

struct AssessmentListView: View {
    let assessments: [RiskAssessmentEntity]

    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(assessments.reversed(), id: \.id) { assessment in
                NavigationLink(destination: AssessmentDetailView(assessment: assessment)) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(NopiFormatters.dateTimeFormatter.string(from: assessment.timestamp))
                                .font(.subheadline)
                            if let topFactor = assessment.factors
                                .sorted(by: { $0.weightedContribution > $1.weightedContribution })
                                .first {
                                Text("Top: \(topFactor.displayName)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 4) {
                            Text("\(Int(assessment.score))")
                                .font(.title3.bold())
                                .foregroundStyle(assessment.level.color)
                            RiskLevelBadge(level: assessment.level)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
                .buttonStyle(.plain)

                Divider()
                    .padding(.leading)
            }
        }
    }
}
