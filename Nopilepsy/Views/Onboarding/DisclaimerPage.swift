import SwiftUI

struct DisclaimerPage: View {
    @Binding var hasScrolled: Bool

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundStyle(.orange)

            Text("Important Disclaimer")
                .font(.title2.bold())

            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    DisclaimerSection(title: "Not a Medical Device", text: "Nopilepsy is not a medical device, not FDA-approved, and not intended to diagnose, treat, cure, or prevent any disease. It is an informational tool only.")

                    DisclaimerSection(title: "Not a Substitute for Professional Care", text: "This app does not replace consultation with your neurologist or healthcare provider. Always follow your doctor's medical advice.")

                    DisclaimerSection(title: "No Seizure Detection", text: "This app monitors risk factors passively. It does not detect or predict individual seizure events in real-time.")

                    DisclaimerSection(title: "Research-Based, Not Clinically Validated", text: "Risk factor weights are derived from published epilepsy research. However, the risk model itself has not been validated in a clinical trial.")

                    DisclaimerSection(title: "Individual Variation", text: "Seizure triggers and patterns vary greatly between individuals. Risk scores should be interpreted as general guidance, not precise predictions.")

                    DisclaimerSection(title: "Data Privacy", text: "All health data is processed and stored on your device. No data is transmitted to any server unless you explicitly enable optional cloud features.")

                    Color.clear
                        .frame(height: 1)
                        .onAppear { hasScrolled = true }
                }
                .padding()
            }

            if hasScrolled {
                Text("Scroll down to read all terms before proceeding")
                    .font(.caption)
                    .foregroundStyle(.green)
            } else {
                Text("Please scroll down to read the complete disclaimer")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
}

private struct DisclaimerSection: View {
    let title: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline.bold())
            Text(text)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
