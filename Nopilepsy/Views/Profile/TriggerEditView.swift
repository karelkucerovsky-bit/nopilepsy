import SwiftUI
import SwiftData
import NopiCore

struct TriggerEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    let viewModel: ProfileViewModel

    @State private var triggerName = ""

    private let commonTriggers = [
        "Sleep Deprivation", "Stress", "Alcohol", "Flashing Lights",
        "Missed Medication", "Illness/Fever", "Menstrual Cycle",
        "Dehydration", "Caffeine", "Extreme Heat", "Exhaustion"
    ]

    var body: some View {
        Form {
            Section("Custom Trigger") {
                HStack {
                    TextField("Trigger name", text: $triggerName)
                    Button("Add") {
                        addTrigger(triggerName)
                        triggerName = ""
                    }
                    .disabled(triggerName.isEmpty)
                }
            }

            Section("Common Triggers") {
                ForEach(commonTriggers, id: \.self) { trigger in
                    Button {
                        addTrigger(trigger)
                    } label: {
                        HStack {
                            Text(trigger)
                                .foregroundStyle(.primary)
                            Spacer()
                            Image(systemName: "plus.circle")
                                .foregroundStyle(.blue)
                        }
                    }
                }
            }
        }
        .navigationTitle("Add Trigger")
    }

    private func addTrigger(_ name: String) {
        viewModel.addTrigger(name, modelContext: modelContext)
    }
}
