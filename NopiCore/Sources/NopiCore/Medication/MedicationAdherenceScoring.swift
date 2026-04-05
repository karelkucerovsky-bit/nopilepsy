import Foundation

public enum MedicationAdherenceScoring {
    /// Calculates adherence score (0.0 = completely missed, 1.0 = perfectly on time)
    /// based on the time since the last dose relative to the expected interval.
    public static func score(
        lastDoseTime: Date?,
        expectedIntervalHours: Double,
        now: Date = Date()
    ) -> Double {
        guard let lastDose = lastDoseTime else {
            return 0.0  // No dose recorded
        }

        let hoursSinceLastDose = now.timeIntervalSince(lastDose) / 3600.0
        let ratio = hoursSinceLastDose / expectedIntervalHours

        switch ratio {
        case ..<1.0: return 1.0      // Early or on time
        case 1.0..<1.25: return 0.9  // Slightly late
        case 1.25..<1.5: return 0.7  // Late
        case 1.5..<2.0: return 0.4   // Very late (approaching missed)
        case 2.0..<3.0: return 0.15  // Missed one dose
        default: return 0.0          // Missed multiple doses
        }
    }

    /// Calculates aggregate adherence across all active medications.
    public static func aggregateAdherence(
        medications: [(lastDoseTime: Date?, intervalHours: Double)],
        now: Date = Date()
    ) -> Double? {
        guard !medications.isEmpty else { return nil }

        let scores = medications.map { med in
            score(lastDoseTime: med.lastDoseTime, expectedIntervalHours: med.intervalHours, now: now)
        }
        return scores.reduce(0, +) / Double(scores.count)
    }
}
