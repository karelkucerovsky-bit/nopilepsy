import SwiftUI
import SwiftData
import NopiCore

struct MedicationEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let medication: MedicationEntity?

    @State private var name: String = ""
    @State private var dosageMg: Double = 500
    @State private var timesPerDay: Int = 2
    @State private var scheduledTimes: [Date] = []
    @State private var isActive: Bool = true

    private var isNew: Bool { medication == nil }

    var body: some View {
        NavigationStack {
            Form {
                Section("Medication") {
                    TextField("Name (e.g. Keppra)", text: $name)
                    HStack {
                        Text("Dosage (mg)")
                        Spacer()
                        TextField("mg", value: $dosageMg, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }
                    Stepper("Times per day: \(timesPerDay)", value: $timesPerDay, in: 1...6)
                        .onChange(of: timesPerDay) {
                            adjustScheduledTimes()
                        }
                }

                Section("Schedule") {
                    ForEach(scheduledTimes.indices, id: \.self) { index in
                        DatePicker(
                            "Dose \(index + 1)",
                            selection: $scheduledTimes[index],
                            displayedComponents: .hourAndMinute
                        )
                    }
                }

                if !isNew {
                    Section {
                        Toggle("Active", isOn: $isActive)

                        NavigationLink("Dose Log") {
                            MedicationLogView(medication: medication!)
                        }
                    }
                }
            }
            .navigationTitle(isNew ? "Add Medication" : "Edit Medication")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(name.isEmpty)
                }
            }
        }
        .onAppear { loadExisting() }
    }

    private func loadExisting() {
        guard let med = medication else {
            adjustScheduledTimes()
            return
        }
        name = med.name
        dosageMg = med.dosageMg
        timesPerDay = med.timesPerDay
        isActive = med.isActive

        let times = med.scheduledTimes
        scheduledTimes = times.map { dc in
            Calendar.current.date(from: dc) ?? Date()
        }
        if scheduledTimes.isEmpty {
            adjustScheduledTimes()
        }
    }

    private func adjustScheduledTimes() {
        let calendar = Calendar.current
        let base = calendar.startOfDay(for: Date())
        scheduledTimes = (0..<timesPerDay).map { i in
            let hour = 8 + (i * (14 / max(timesPerDay, 1)))
            return calendar.date(bySettingHour: hour, minute: 0, second: 0, of: base) ?? base
        }
    }

    private func save() {
        let calendar = Calendar.current
        let components = scheduledTimes.map { date in
            calendar.dateComponents([.hour, .minute], from: date)
        }

        if let existing = medication {
            existing.name = name
            existing.dosageMg = dosageMg
            existing.timesPerDay = timesPerDay
            existing.scheduledTimes = components
            existing.isActive = isActive
        } else {
            let med = MedicationEntity(name: name, dosageMg: dosageMg, timesPerDay: timesPerDay)
            med.scheduledTimes = components
            med.isActive = isActive

            // Auto-attach to profile
            let profileDesc = FetchDescriptor<UserProfileEntity>()
            if let profile = try? modelContext.fetch(profileDesc).first {
                med.profile = profile
            }
            modelContext.insert(med)
        }
        try? modelContext.save()
        dismiss()
    }
}
