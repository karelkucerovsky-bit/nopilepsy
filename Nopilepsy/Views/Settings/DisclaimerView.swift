import SwiftUI

struct DisclaimerView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Medical Disclaimer")
                    .font(.title2.bold())

                Group {
                    DisclaimerBlock(
                        title: "Not a Medical Device",
                        text: "Nopilepsy is not a medical device and has not been approved or cleared by the FDA or any other regulatory agency. It is not intended to diagnose, treat, cure, or prevent any disease or medical condition."
                    )

                    DisclaimerBlock(
                        title: "Informational Use Only",
                        text: "The risk scores, factor analyses, and other information provided by this app are for general informational purposes only. They should not be used as a substitute for professional medical advice, diagnosis, or treatment."
                    )

                    DisclaimerBlock(
                        title: "Consult Your Doctor",
                        text: "Always seek the advice of your neurologist or other qualified health provider with any questions you may have regarding your epilepsy or other medical conditions. Never disregard professional medical advice or delay seeking it because of information provided by this app."
                    )

                    DisclaimerBlock(
                        title: "No Seizure Detection",
                        text: "This app does not detect seizures in real-time. It monitors health metrics that published research has associated with seizure risk. The absence of an elevated risk score does not mean a seizure cannot occur."
                    )

                    DisclaimerBlock(
                        title: "Research Basis",
                        text: "Risk factor weights are derived from published peer-reviewed epilepsy research. However, the composite risk model has not been independently validated in a clinical trial. Individual results will vary."
                    )

                    DisclaimerBlock(
                        title: "Data Accuracy",
                        text: "Health sensor data from Apple Watch may contain inaccuracies. Nopilepsy processes this data as-is and cannot guarantee the accuracy of the underlying sensor readings."
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Disclaimer")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct DisclaimerBlock: View {
    let title: String
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}
