import Foundation
import SwiftData

public final class MedicationScheduleManager: @unchecked Sendable {
    private let modelContext: ModelContext

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    public func getActiveMedications() -> [MedicationEntity] {
        let descriptor = FetchDescriptor<MedicationEntity>(
            predicate: #Predicate { $0.isActive }
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }

    public func calculateCurrentAdherence() -> Double? {
        let medications = getActiveMedications()
        guard !medications.isEmpty else { return nil }

        let medData: [(lastDoseTime: Date?, intervalHours: Double)] = medications.map { med in
            let lastDose = med.logs
                .filter { $0.taken }
                .sorted { $0.timestamp > $1.timestamp }
                .first?.timestamp
            let intervalHours = 24.0 / Double(max(med.timesPerDay, 1))
            return (lastDoseTime: lastDose, intervalHours: intervalHours)
        }

        return MedicationAdherenceScoring.aggregateAdherence(medications: medData)
    }

    public func logDose(for medication: MedicationEntity, taken: Bool = true, notes: String? = nil) {
        let log = MedicationLogEntity(taken: taken, notes: notes)
        log.medication = medication
        modelContext.insert(log)
        try? modelContext.save()
    }

    public func nextScheduledDose(for medication: MedicationEntity) -> DateComponents? {
        let times = medication.scheduledTimes
        guard !times.isEmpty else { return nil }

        let now = Date()
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: now)
        let currentMinute = calendar.component(.minute, from: now)

        // Find next scheduled time today or tomorrow
        for time in times.sorted(by: { ($0.hour ?? 0) * 60 + ($0.minute ?? 0) < ($1.hour ?? 0) * 60 + ($1.minute ?? 0) }) {
            let schedMinutes = (time.hour ?? 0) * 60 + (time.minute ?? 0)
            let currentMinutes = currentHour * 60 + currentMinute
            if schedMinutes > currentMinutes {
                return time
            }
        }

        // Wrap to first dose tomorrow
        return times.sorted(by: { ($0.hour ?? 0) * 60 + ($0.minute ?? 0) < ($1.hour ?? 0) * 60 + ($1.minute ?? 0) }).first
    }
}
