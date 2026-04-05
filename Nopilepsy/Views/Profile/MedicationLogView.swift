import SwiftUI
import SwiftData
import NopiCore

struct MedicationLogView: View {
    @Environment(\.modelContext) private var modelContext
    let medication: MedicationEntity

    private var sortedLogs: [MedicationLogEntity] {
        medication.logs.sorted { $0.timestamp > $1.timestamp }
    }

    var body: some View {
        List {
            ForEach(sortedLogs, id: \.id) { log in
                HStack {
                    Image(systemName: log.taken ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundStyle(log.taken ? .green : .red)

                    VStack(alignment: .leading) {
                        Text(NopiFormatters.dateTimeFormatter.string(from: log.timestamp))
                            .font(.subheadline)
                        if let notes = log.notes, !notes.isEmpty {
                            Text(notes)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Spacer()

                    Text(log.taken ? "Taken" : "Missed")
                        .font(.caption)
                        .foregroundStyle(log.taken ? .green : .red)
                }
            }
        }
        .navigationTitle("Dose Log")
        .toolbar {
            Button {
                let manager = MedicationScheduleManager(modelContext: modelContext)
                manager.logDose(for: medication)
            } label: {
                Label("Log Dose", systemImage: "plus")
            }
        }
        .overlay {
            if sortedLogs.isEmpty {
                EmptyStateView(
                    icon: "list.bullet",
                    title: "No Doses Logged",
                    message: "Dose records will appear here when you log them from your Watch or iPhone."
                )
            }
        }
    }
}
