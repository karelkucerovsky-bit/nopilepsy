import SwiftUI
import SwiftData
import NopiCore

struct MedicationListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var medications: [MedicationEntity]
    @State private var showingAddSheet = false

    var body: some View {
        List {
            ForEach(medications, id: \.id) { med in
                NavigationLink(destination: MedicationEditView(medication: med)) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(med.name)
                                .font(.headline)
                            if !med.isActive {
                                Text("Inactive")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(.gray.opacity(0.15))
                                    .clipShape(Capsule())
                            }
                        }
                        Text("\(Int(med.dosageMg))mg, \(med.timesPerDay)x daily")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    modelContext.delete(medications[index])
                }
                try? modelContext.save()
            }
        }
        .navigationTitle("Medications")
        .toolbar {
            Button {
                showingAddSheet = true
            } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            MedicationEditView(medication: nil)
        }
        .overlay {
            if medications.isEmpty {
                EmptyStateView(
                    icon: "pills.fill",
                    title: "No Medications",
                    message: "Add your anti-epileptic medications to track adherence and improve risk assessment.",
                    action: { showingAddSheet = true },
                    actionLabel: "Add Medication"
                )
            }
        }
    }
}
