import Testing
@testable import NopiCore

@Suite("ThresholdRules")
struct ThresholdRuleTests {

    // MARK: - Sleep Duration

    @Test("Sleep 8h = no risk")
    func sleepNormal() {
        let snapshot = HealthSnapshot(sleepDurationHours: 8.0)
        let score = SleepDurationRule().evaluate(snapshot: snapshot)
        #expect(score == 0.0)
    }

    @Test("Sleep 4h = high risk")
    func sleepDeprived() {
        let snapshot = HealthSnapshot(sleepDurationHours: 4.0)
        let score = SleepDurationRule().evaluate(snapshot: snapshot)
        #expect(score == 0.75)
    }

    @Test("Sleep 3h = very high risk")
    func sleepSeverelyDeprived() {
        let snapshot = HealthSnapshot(sleepDurationHours: 3.0)
        let score = SleepDurationRule().evaluate(snapshot: snapshot)
        #expect(score == 0.9)
    }

    @Test("Sleep missing = nil")
    func sleepMissing() {
        let snapshot = HealthSnapshot()
        let score = SleepDurationRule().evaluate(snapshot: snapshot)
        #expect(score == nil)
    }

    // MARK: - HRV

    @Test("HRV 80ms = healthy")
    func hrvHealthy() {
        let snapshot = HealthSnapshot(hrvMs: 80)
        let score = HRVRule().evaluate(snapshot: snapshot)
        #expect(score == 0.0)
    }

    @Test("HRV 25ms = very high risk")
    func hrvLow() {
        let snapshot = HealthSnapshot(hrvMs: 25)
        let score = HRVRule().evaluate(snapshot: snapshot)
        #expect(score == 0.9)
    }

    // MARK: - SpO2

    @Test("SpO2 98% = healthy")
    func spo2Normal() {
        let snapshot = HealthSnapshot(spO2Percent: 98)
        let score = SpO2Rule().evaluate(snapshot: snapshot)
        #expect(score == 0.0)
    }

    @Test("SpO2 91% = elevated risk")
    func spo2Low() {
        let snapshot = HealthSnapshot(spO2Percent: 91)
        let score = SpO2Rule().evaluate(snapshot: snapshot)
        #expect(score == 0.6)
    }

    // MARK: - Resting Heart Rate

    @Test("RHR 65 = healthy")
    func rhrNormal() {
        let snapshot = HealthSnapshot(restingHeartRate: 65)
        let score = RestingHeartRateRule().evaluate(snapshot: snapshot)
        #expect(score == 0.0)
    }

    @Test("RHR 105 = tachycardia risk")
    func rhrHigh() {
        let snapshot = HealthSnapshot(restingHeartRate: 105)
        let score = RestingHeartRateRule().evaluate(snapshot: snapshot)
        #expect(score == 0.8)
    }

    // MARK: - Activity

    @Test("Activity 8000 steps = healthy")
    func activityNormal() {
        let snapshot = HealthSnapshot(activitySteps: 8000)
        let score = ActivityLevelRule().evaluate(snapshot: snapshot)
        #expect(score == 0.0)
    }

    @Test("Activity 500 steps = sedentary risk")
    func activityLow() {
        let snapshot = HealthSnapshot(activitySteps: 500)
        let score = ActivityLevelRule().evaluate(snapshot: snapshot)
        #expect(score == 0.4)
    }

    // MARK: - Stress Proxy

    @Test("Stress proxy with high HR + low HRV")
    func stressHigh() {
        let snapshot = HealthSnapshot(hrvMs: 25, restingHeartRate: 95)
        let score = StressProxyRule().evaluate(snapshot: snapshot)
        #expect(score != nil)
        #expect(score! > 0.5)
    }

    @Test("Stress proxy with healthy metrics")
    func stressLow() {
        let snapshot = HealthSnapshot(hrvMs: 80, restingHeartRate: 65)
        let score = StressProxyRule().evaluate(snapshot: snapshot)
        #expect(score == 0.0)
    }
}
