import SwiftUI

struct HealthKitPermissionPage: View {
    @Binding var authorized: Bool
    let requestAction: () async -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: authorized ? "heart.circle.fill" : "heart.circle")
                .font(.system(size: 64))
                .foregroundStyle(authorized ? .green : .red.gradient)

            Text("Health Data Access")
                .font(.title2.bold())

            Text("Nopilepsy needs access to your Apple Watch health sensors to calculate seizure risk.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            VStack(alignment: .leading, spacing: 8) {
                PermissionRow(name: "Sleep Analysis")
                PermissionRow(name: "Heart Rate & HRV")
                PermissionRow(name: "Blood Oxygen")
                PermissionRow(name: "Temperature")
                PermissionRow(name: "Activity (Steps)")
            }
            .padding(.horizontal, 40)

            if authorized {
                Label("Access Granted", systemImage: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.headline)
            } else {
                Button {
                    Task { await requestAction() }
                } label: {
                    Text("Allow Health Access")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(14)
                }
                .padding(.horizontal, 32)
            }

            Spacer()

            Text("You can change permissions in Settings > Privacy > Health")
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .padding(.bottom, 32)
        }
        .padding()
    }
}

private struct PermissionRow: View {
    let name: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.shield.fill")
                .foregroundStyle(.blue)
                .font(.caption)
            Text(name)
                .font(.subheadline)
        }
    }
}
