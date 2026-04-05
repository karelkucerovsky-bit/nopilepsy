import SwiftUI
import SwiftData
import NopiCore

struct WatchMedicationView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<MedicationEntity> { $0.isActive })
    private var medications: [MedicationEntity]
    @State private var justLogged = false

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                if medications.isEmpty {
                    Text("No medications configured")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("Add medications on your iPhone")
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                } else {
                    ForEach(medications, id: \.id) { med in
                        VStack(spacing: 8) {
                            Text(med.name)
                                .font(.headline)
                            Text("\(Int(med.dosageMg))mg")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Button {
                                logDose(for: med)
                            } label: {
                                Label(
                                    justLogged ? "Logged" : "Taken",
                                    systemImage: justLogged ? "checkmark.circle.fill" : "pills.fill"
                                )
                                .font(.body)
                            }
                            .tint(justLogged ? .green : .blue)
                            .disabled(justLogged)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Medication")
    }

    private func logDose(for medication: MedicationEntity) {
        let manager = MedicationScheduleManager(modelContext: modelContext)
        manager.logDose(for: medication)
        justLogged = true

        // Reset after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            justLogged = false
        }
    }
}
