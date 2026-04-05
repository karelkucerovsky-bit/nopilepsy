import SwiftUI

struct ProfileSetupPage: View {
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 64))
                .foregroundStyle(.green.gradient)

            Text("You're All Set")
                .font(.title2.bold())

            Text("Nopilepsy will start monitoring your health data and building your personal baseline.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            VStack(alignment: .leading, spacing: 12) {
                SetupNote(icon: "gauge.medium", text: "Risk dashboard available immediately")
                SetupNote(icon: "chart.line.uptrend.xyaxis", text: "Personal baseline calibrates over 2-4 weeks")
                SetupNote(icon: "person.crop.circle", text: "Add your epilepsy profile in Settings (optional)")
                SetupNote(icon: "bell.slash", text: "Notifications are off by default")
            }
            .padding(.horizontal, 24)

            Spacer()

            Button {
                onComplete()
            } label: {
                Text("I Understand — Start Monitoring")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(14)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 48)
        }
        .padding()
    }
}

private struct SetupNote: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.blue)
                .frame(width: 24)
            Text(text)
                .font(.subheadline)
        }
    }
}
