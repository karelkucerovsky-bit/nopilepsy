import Testing
import Foundation
@testable import NopiCore

@Suite("MedicationAdherenceScoring")
struct MedicationAdherenceTests {

    @Test("On-time dose scores 1.0")
    func onTimeDose() {
        let now = Date()
        let lastDose = now.addingTimeInterval(-6 * 3600) // 6 hours ago
        let score = MedicationAdherenceScoring.score(lastDoseTime: lastDose, expectedIntervalHours: 12, now: now)
        #expect(score == 1.0)
    }

    @Test("Slightly late dose scores 0.9")
    func slightlyLateDose() {
        let now = Date()
        let lastDose = now.addingTimeInterval(-13 * 3600) // 13h for 12h interval
        let score = MedicationAdherenceScoring.score(lastDoseTime: lastDose, expectedIntervalHours: 12, now: now)
        #expect(score == 0.9)
    }

    @Test("Late dose scores 0.7")
    func lateDose() {
        let now = Date()
        let lastDose = now.addingTimeInterval(-16 * 3600) // 16h for 12h interval
        let score = MedicationAdherenceScoring.score(lastDoseTime: lastDose, expectedIntervalHours: 12, now: now)
        #expect(score == 0.7)
    }

    @Test("Missed dose scores low")
    func missedDose() {
        let now = Date()
        let lastDose = now.addingTimeInterval(-30 * 3600) // 30h for 12h interval
        let score = MedicationAdherenceScoring.score(lastDoseTime: lastDose, expectedIntervalHours: 12, now: now)
        #expect(score == 0.15)
    }

    @Test("No dose recorded scores 0.0")
    func noDoseRecorded() {
        let score = MedicationAdherenceScoring.score(lastDoseTime: nil, expectedIntervalHours: 12)
        #expect(score == 0.0)
    }

    @Test("Aggregate with no medications returns nil")
    func noMedications() {
        let result = MedicationAdherenceScoring.aggregateAdherence(medications: [])
        #expect(result == nil)
    }

    @Test("Aggregate with mixed adherence")
    func mixedAdherence() {
        let now = Date()
        let meds: [(lastDoseTime: Date?, intervalHours: Double)] = [
            (lastDoseTime: now.addingTimeInterval(-6 * 3600), intervalHours: 12),  // on time
            (lastDoseTime: now.addingTimeInterval(-30 * 3600), intervalHours: 12)  // missed
        ]
        let result = MedicationAdherenceScoring.aggregateAdherence(medications: meds, now: now)
        #expect(result != nil)
        #expect(result! > 0.3)
        #expect(result! < 0.8)
    }
}
