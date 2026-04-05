import SwiftUI
import NopiCore

struct ResearchTransparencyPage: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "book.closed.fill")
                .font(.system(size: 48))
                .foregroundStyle(.purple.gradient)

            Text("Research-Backed")
                .font(.title2.bold())

            Text("How We Calculate Risk")
                .font(.headline)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 12) {
                TransparencyRow(
                    icon: "1.circle.fill",
                    title: "Published Thresholds",
                    text: "Risk factor weights come from \(Citations.all.count) published epilepsy studies"
                )
                TransparencyRow(
                    icon: "2.circle.fill",
                    title: "Personal Baseline",
                    text: "After 2 weeks, the model learns your individual patterns"
                )
                TransparencyRow(
                    icon: "3.circle.fill",
                    title: "Hybrid Scoring",
                    text: "Combines population research with your personal data"
                )
                TransparencyRow(
                    icon: "4.circle.fill",
                    title: "Full Transparency",
                    text: "Every factor shows its research citation — you can verify"
                )
            }
            .padding(.horizontal)

            Text("All citations are viewable in Settings")
                .font(.caption)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding()
    }
}

private struct TransparencyRow: View {
    let icon: String
    let title: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.purple)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.bold())
                Text(text)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
