import SwiftUI
import SwiftData
import NopiCore

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ProfileViewModel()
    @Query(filter: #Predicate<MedicationEntity> { $0.isActive })
    private var activeMedications: [MedicationEntity]
    @Query private var seizureLogs: [SeizureLogEntity]

    private let seizureTypes = ["Focal", "Generalized", "Unknown", "Focal to Bilateral", "Absence", "Tonic-Clonic", "Myoclonic"]

    var body: some View {
        NavigationStack {
            List {
                // Seizure type
                Section("Epilepsy Type") {
                    Picker("Seizure Type", selection: Binding(
                        get: { viewModel.profile?.seizureType ?? "" },
                        set: { viewModel.updateSeizureType($0.isEmpty ? nil : $0, modelContext: modelContext) }
                    )) {
                        Text("Not specified").tag("")
                        ForEach(seizureTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                }

                // Medications
                Section {
                    NavigationLink("Medications (\(activeMedications.count))") {
                        MedicationListView()
                    }
                } header: {
                    Text("Medications")
                } footer: {
                    Text("Tracking medication timing improves risk assessment accuracy.")
                }

                // Triggers
                Section("Known Triggers") {
                    let triggers = viewModel.profile?.triggers.filter(\.isActive) ?? []
                    if triggers.isEmpty {
                        Text("No triggers added")
                            .foregroundStyle(.secondary)
                    }
                    ForEach(triggers, id: \.id) { trigger in
                        Text(trigger.name)
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            viewModel.removeTrigger(triggers[index], modelContext: modelContext)
                        }
                    }

                    NavigationLink("Add Trigger") {
                        TriggerEditView(viewModel: viewModel)
                    }
                }

                // Seizure log
                Section {
                    NavigationLink("Seizure Log (\(seizureLogs.count))") {
                        SeizureLogListView()
                    }
                } header: {
                    Text("Seizure History")
                } footer: {
                    Text("Recording seizure events helps identify patterns in your risk data.")
                }

                // Sensor status
                Section("Sensor Status") {
                    NavigationLink("Connected Sensors") {
                        SensorStatusView(availability: viewModel.sensorAvailability)
                    }
                }
            }
            .navigationTitle("Profile")
        }
        .onAppear {
            viewModel.setup(modelContext: modelContext)
        }
    }
}
