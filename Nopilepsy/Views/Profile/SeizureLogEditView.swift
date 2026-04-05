import SwiftUI
import SwiftData
import NopiCore

struct SeizureLogEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var timestamp = Date()
    @State private var seizureType = ""
    @State private var durationSeconds: Int?
    @State private var notes = ""

    @Query(sort: \RiskAssessmentEntity.timestamp, order: .reverse)
    private var recentAssessments: [RiskAssessmentEntity]

    private let seizureTypes = ["Focal", "Generalized", "Tonic-Clonic", "Absence", "Myoclonic", "Atonic", "Unknown"]

    var body: some View {
        NavigationStack {
            Form {
                Section("When") {
                    DatePicker("Date & Time", selection: $timestamp)
                }

                Section("Details") {
                    Picker("Seizure Type", selection: $seizureType) {
                        Text("Not specified").tag("")
                        ForEach(seizureTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }

                    HStack {
                        Text("Duration (seconds)")
                        Spacer()
                        TextField("Optional", value: $durationSeconds, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                }

                Section("Notes") {
                    TextField("Any additional observations...", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Log Seizure")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                }
            }
        }
    }

    private func save() {
        let log = SeizureLogEntity(
            timestamp: timestamp,
            typeRaw: seizureType.isEmpty ? nil : seizureType,
            durationSeconds: durationSeconds,
            notes: notes.isEmpty ? nil : notes,
            preSeizureRiskScore: recentAssessments.first?.score
        )

        // Attach to profile
        let profileDesc = FetchDescriptor<UserProfileEntity>()
        if let profile = try? modelContext.fetch(profileDesc).first {
            log.profile = profile
        }

        modelContext.insert(log)
        try? modelContext.save()
        dismiss()
    }
}
