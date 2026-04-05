import SwiftUI
import SwiftData
import NopiCore

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = SettingsViewModel()
    @State private var showExport = false
    @State private var showResetConfirm = false
    @State private var showResetFinalConfirm = false

    var body: some View {
        NavigationStack {
            List {
                // Notifications
                Section {
                    Toggle("Notifications", isOn: Binding(
                        get: { viewModel.settings?.notificationsEnabled ?? false },
                        set: { enabled in
                            Task { await viewModel.toggleNotifications(enabled, modelContext: modelContext) }
                        }
                    ))

                    if viewModel.settings?.notificationsEnabled == true {
                        NavigationLink("Notification Settings") {
                            NotificationSettingsView(viewModel: viewModel)
                        }
                    }
                } header: {
                    Text("Notifications")
                } footer: {
                    Text("Receive alerts when your risk level reaches the configured threshold.")
                }

                // Export
                Section("Data Export") {
                    Button("Export Report") {
                        showExport = true
                    }
                }

                // Data
                Section {
                    HStack {
                        Text("Data Retention")
                        Spacer()
                        Text("\(viewModel.settings?.dataRetentionDays ?? 365) days")
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("Data Management")
                }

                // Research
                Section("Research") {
                    NavigationLink("View Citations (\(Citations.all.count))") {
                        CitationsListView()
                    }
                }

                // Legal
                Section("Legal") {
                    NavigationLink("Medical Disclaimer") {
                        DisclaimerView()
                    }
                }

                // Baseline
                Section {
                    Button("Reset Personal Baseline", role: .destructive) {
                        showResetConfirm = true
                    }
                } footer: {
                    Text("Clears your personal baseline data. The model will need 2-4 weeks to recalibrate.")
                }

                // About
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Risk Model")
                        Spacer()
                        Text("v\(RiskEngine.modelVersion)")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("License")
                        Spacer()
                        Text("MIT")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showExport) {
                ExportView()
            }
            .alert("Reset Baseline?", isPresented: $showResetConfirm) {
                Button("Cancel", role: .cancel) {}
                Button("Reset", role: .destructive) {
                    showResetFinalConfirm = true
                }
            } message: {
                Text("This will delete your personal baseline data. The risk engine will use only population thresholds until recalibrated (2-4 weeks).")
            }
            .alert("Are you sure?", isPresented: $showResetFinalConfirm) {
                Button("Cancel", role: .cancel) {}
                Button("Yes, Reset", role: .destructive) {
                    viewModel.resetBaseline(modelContext: modelContext)
                }
            } message: {
                Text("This action cannot be undone.")
            }
        }
        .onAppear {
            viewModel.setup(modelContext: modelContext)
        }
    }
}
