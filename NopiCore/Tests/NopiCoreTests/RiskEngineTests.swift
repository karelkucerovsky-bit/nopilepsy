import Testing
@testable import NopiCore

@Suite("RiskEngine")
struct RiskEngineTests {
    let engine = RiskEngine()

    @Test("Low risk with healthy metrics")
    func lowRiskHealthyMetrics() {
        let snapshot = HealthSnapshot(
            sleepDurationHours: 8.0,
            sleepStages: SleepStages(deepMinutes: 90, coreMinutes: 180, remMinutes: 90, awakeMinutes: 30),
            hrvMs: 75,
            restingHeartRate: 65,
            spO2Percent: 98,
            skinTempCelsius: 0.1,
            activitySteps: 8000,
            sensorAvailability: .allAvailable
        )

        let result = engine.calculateRisk(snapshot: snapshot, baseline: nil, medicationAdherence: nil)

        #expect(result.level == .low)
        #expect(result.score <= 25)
        #expect(result.confidence > 0.5)
    }

    @Test("High risk with poor metrics")
    func highRiskPoorMetrics() {
        let snapshot = HealthSnapshot(
            sleepDurationHours: 3.0,
            sleepStages: SleepStages(deepMinutes: 10, coreMinutes: 100, remMinutes: 30, awakeMinutes: 40),
            hrvMs: 25,
            restingHeartRate: 105,
            spO2Percent: 89,
            skinTempCelsius: 1.2,
            activitySteps: 500,
            sensorAvailability: .allAvailable
        )

        let result = engine.calculateRisk(snapshot: snapshot, baseline: nil, medicationAdherence: 0.1)

        #expect(result.level == .high)
        #expect(result.score > 50)
    }

    @Test("Missing sensors reduce confidence")
    func missingSensorsReduceConfidence() {
        let snapshot = HealthSnapshot(
            sleepDurationHours: 7.5,
            sensorAvailability: SensorAvailability(sleepTracking: true)
        )

        let result = engine.calculateRisk(snapshot: snapshot, baseline: nil, medicationAdherence: nil)

        #expect(result.confidence < 0.5)
        #expect(!result.factors.isEmpty)
    }

    @Test("Empty snapshot produces zero score with zero confidence")
    func emptySnapshotZeroScore() {
        let snapshot = HealthSnapshot()
        let result = engine.calculateRisk(snapshot: snapshot, baseline: nil, medicationAdherence: nil)

        #expect(result.score == 0)
        #expect(result.confidence == 0)
    }

    @Test("Factors are sorted by weighted contribution")
    func factorsSortedByContribution() {
        let snapshot = HealthSnapshot(
            sleepDurationHours: 4.0,
            hrvMs: 25,
            restingHeartRate: 65,
            sensorAvailability: .allAvailable
        )

        let result = engine.calculateRisk(snapshot: snapshot, baseline: nil, medicationAdherence: nil)

        for i in 0..<(result.factors.count - 1) {
            #expect(result.factors[i].weightedContribution >= result.factors[i + 1].weightedContribution)
        }
    }

    @Test("Medication adherence affects score")
    func medicationAdherenceAffectsScore() {
        let snapshot = HealthSnapshot(
            sleepDurationHours: 7.5,
            hrvMs: 70,
            sensorAvailability: .allAvailable
        )

        let goodAdherence = engine.calculateRisk(snapshot: snapshot, baseline: nil, medicationAdherence: 1.0)
        let poorAdherence = engine.calculateRisk(snapshot: snapshot, baseline: nil, medicationAdherence: 0.1)

        #expect(poorAdherence.score > goodAdherence.score)
    }

    @Test("Risk levels map correctly")
    func riskLevelMapping() {
        #expect(RiskLevel.from(score: 0) == .low)
        #expect(RiskLevel.from(score: 25) == .low)
        #expect(RiskLevel.from(score: 26) == .moderate)
        #expect(RiskLevel.from(score: 50) == .moderate)
        #expect(RiskLevel.from(score: 51) == .elevated)
        #expect(RiskLevel.from(score: 75) == .elevated)
        #expect(RiskLevel.from(score: 76) == .high)
        #expect(RiskLevel.from(score: 100) == .high)
    }
}
