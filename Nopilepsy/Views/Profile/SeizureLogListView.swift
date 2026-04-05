import SwiftUI
import SwiftData
import NopiCore

struct SeizureLogListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SeizureLogEntity.timestamp, order: .reverse)
    private var logs: [SeizureLogEntity]
    @State private var showingAddSheet = false

    var body: some View {
        List {
            ForEach(logs, id: \.id) { log in
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(NopiFormatters.dateTimeFormatter.string(from: log.timestamp))
                            .font(.subheadline.weight(.medium))
                        Spacer()
                        if let score = log.preSeizureRiskScore {
                            RiskLevelBadge(level: RiskLevel.from(score: score))
                        }
                    }

                    HStack(spacing: 12) {
                        if let type = log.typeRaw {
                            Label(type, systemImage: "bolt.fill")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        if let duration = log.durationSeconds {
                            Label("\(duration)s", systemImage: "clock")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    if let notes = log.notes, !notes.isEmpty {
                        Text(notes)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 2)
            }
            .onDelete { indexSet in
                for index in indexSet {
                    modelContext.delete(logs[index])
                }
                try? modelContext.save()
            }
        }
        .navigationTitle("Seizure Log")
        .toolbar {
            Button { showingAddSheet = true } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            SeizureLogEditView()
        }
        .overlay {
            if logs.isEmpty {
                EmptyStateView(
                    icon: "list.bullet.clipboard",
                    title: "No Seizure Events",
                    message: "Recording seizure events helps identify patterns in your risk data."
                )
            }
        }
    }
}
