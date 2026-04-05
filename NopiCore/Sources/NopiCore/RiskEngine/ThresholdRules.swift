import Foundation

public struct SleepDurationRule: ThresholdRule {
    public init() {}

    public func evaluate(snapshot: HealthSnapshot) -> Double? {
        guard let hours = snapshot.sleepDurationHours else { return nil }
        switch hours {
        case ..<4: return 0.9
        case 4..<5: return 0.75
        case 5..<6: return 0.5
        case 6..<7: return 0.2
        case 7...9: return 0.0
        case 9..<10: return 0.1
        default: return 0.3  // >10h hypersomnia
        }
    }
}

public struct SleepQualityRule: ThresholdRule {
    public init() {}

    public func evaluate(snapshot: HealthSnapshot) -> Double? {
        guard let stages = snapshot.sleepStages else { return nil }
        let deepPct = stages.deepPercent
        switch deepPct {
        case ..<10: return 0.8
        case 10..<15: return 0.5
        case 15..<20: return 0.2
        default: return 0.0  // >=20% deep sleep is healthy
        }
    }
}

public struct HRVRule: ThresholdRule {
    public init() {}

    public func evaluate(snapshot: HealthSnapshot) -> Double? {
        guard let hrv = snapshot.hrvMs else { return nil }
        switch hrv {
        case ..<30: return 0.9
        case 30..<50: return 0.6
        case 50..<70: return 0.3
        default: return 0.0  // >=70ms is healthy
        }
    }
}

public struct RestingHeartRateRule: ThresholdRule {
    public init() {}

    public func evaluate(snapshot: HealthSnapshot) -> Double? {
        guard let rhr = snapshot.restingHeartRate else { return nil }
        switch rhr {
        case ..<60: return 0.0   // healthy low
        case 60..<80: return 0.0
        case 80..<90: return 0.2
        case 90..<100: return 0.5
        default: return 0.8  // >=100 tachycardia
        }
    }
}

public struct SpO2Rule: ThresholdRule {
    public init() {}

    public func evaluate(snapshot: HealthSnapshot) -> Double? {
        guard let spo2 = snapshot.spO2Percent else { return nil }
        switch spo2 {
        case 97...: return 0.0
        case 95..<97: return 0.1
        case 94..<95: return 0.3
        case 90..<94: return 0.6
        default: return 0.9  // <90% severe
        }
    }
}

public struct SkinTemperatureRule: ThresholdRule {
    public init() {}

    public func evaluate(snapshot: HealthSnapshot) -> Double? {
        guard let temp = snapshot.skinTempCelsius else { return nil }
        // Wrist temperature during sleep is typically 33-36°C
        // We use deviation from a reference. HealthKit provides deviation from baseline.
        let absDeviation = abs(temp)
        switch absDeviation {
        case ..<0.3: return 0.0
        case 0.3..<0.5: return 0.2
        case 0.5..<1.0: return 0.5
        default: return 0.8
        }
    }
}

public struct ActivityLevelRule: ThresholdRule {
    public init() {}

    public func evaluate(snapshot: HealthSnapshot) -> Double? {
        guard let steps = snapshot.activitySteps else { return nil }
        switch steps {
        case ..<1000: return 0.4   // very sedentary
        case 1000..<2000: return 0.3
        case 2000..<5000: return 0.1
        case 5000..<15000: return 0.0
        case 15000..<25000: return 0.1
        default: return 0.4  // extreme exhaustion risk
        }
    }
}

public struct MedicationAdherenceRule: ThresholdRule {
    public init() {}

    /// Evaluates based on adherence ratio (0.0 = missed, 1.0 = on time)
    /// Pass nil if medication is not configured
    public func evaluate(snapshot: HealthSnapshot) -> Double? {
        // Medication adherence is handled separately via the medication manager
        // This rule returns nil if no medication data is available
        nil
    }
}

public struct StressProxyRule: ThresholdRule {
    public init() {}

    public func evaluate(snapshot: HealthSnapshot) -> Double? {
        // Composite of elevated HR + depressed HRV
        guard let rhr = snapshot.restingHeartRate, let hrv = snapshot.hrvMs else { return nil }

        var score = 0.0
        // HR component
        if rhr > 90 { score += 0.4 }
        else if rhr > 80 { score += 0.2 }

        // HRV component (low HRV = high stress)
        if hrv < 30 { score += 0.5 }
        else if hrv < 50 { score += 0.3 }
        else if hrv < 70 { score += 0.1 }

        return min(score, 1.0)
    }
}

public enum ThresholdRules {
    public static func rule(for category: FactorCategory) -> ThresholdRule {
        switch category {
        case .sleepDuration: SleepDurationRule()
        case .sleepQuality: SleepQualityRule()
        case .hrv: HRVRule()
        case .restingHeartRate: RestingHeartRateRule()
        case .spO2: SpO2Rule()
        case .skinTemperature: SkinTemperatureRule()
        case .activityLevel: ActivityLevelRule()
        case .medicationAdherence: MedicationAdherenceRule()
        case .stressProxy: StressProxyRule()
        }
    }
}
