import SwiftUI
import SwiftData
import NopiCore

struct NotificationSettingsView: View {
    @Environment(\.modelContext) private var modelContext
    let viewModel: SettingsViewModel

    var body: some View {
        List {
            Section {
                Picker("Alert Threshold", selection: Binding(
                    get: { viewModel.settings?.notificationThreshold ?? .high },
                    set: { viewModel.updateThreshold($0, modelContext: modelContext) }
                )) {
                    Text("Elevated or High").tag(RiskLevel.elevated)
                    Text("High Only").tag(RiskLevel.high)
                }
            } header: {
                Text("Threshold")
            } footer: {
                Text("You'll receive a notification when your risk level reaches or exceeds this threshold.")
            }
        }
        .navigationTitle("Notifications")
    }
}
