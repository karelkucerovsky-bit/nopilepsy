import SwiftUI

struct WelcomePage: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "brain.head.profile")
                .font(.system(size: 72))
                .foregroundStyle(.blue.gradient)

            Text("Nopilepsy")
                .font(.largeTitle.bold())

            Text("Passive seizure risk monitoring")
                .font(.title3)
                .foregroundStyle(.secondary)

            VStack(alignment: .leading, spacing: 16) {
                FeatureRow(icon: "gauge.medium", color: .green, text: "Real-time risk dashboard")
                FeatureRow(icon: "waveform.path.ecg", color: .blue, text: "Health sensor analysis")
                FeatureRow(icon: "book.closed", color: .purple, text: "Research-backed insights")
                FeatureRow(icon: "lock.shield", color: .orange, text: "100% on-device privacy")
            }
            .padding(.top, 8)

            Spacer()

            Text("Swipe to continue")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .padding(.bottom, 32)
        }
        .padding(.horizontal, 32)
    }
}

private struct FeatureRow: View {
    let icon: String
    let color: Color
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 28)
            Text(text)
                .font(.subheadline)
        }
    }
}
