import Foundation

public enum RiskFactorTable {
    public static let factors: [RiskFactor] = [
        RiskFactor(category: .sleepDuration, baseWeight: 0.22, citation: Citations.sleepDeprivation),
        RiskFactor(category: .sleepQuality, baseWeight: 0.10, citation: Citations.sleepArchitecture),
        RiskFactor(category: .hrv, baseWeight: 0.20, citation: Citations.hrvAutonomic),
        RiskFactor(category: .restingHeartRate, baseWeight: 0.10, citation: Citations.ictalTachycardia),
        RiskFactor(category: .spO2, baseWeight: 0.08, citation: Citations.oxygenDesaturation),
        RiskFactor(category: .skinTemperature, baseWeight: 0.05, citation: Citations.febrileTemperature),
        RiskFactor(category: .activityLevel, baseWeight: 0.05, citation: Citations.exhaustionTrigger),
        RiskFactor(category: .medicationAdherence, baseWeight: 0.15, citation: Citations.missedAED),
        RiskFactor(category: .stressProxy, baseWeight: 0.05, citation: Citations.stressTrigger)
    ]

    public static func factor(for category: FactorCategory) -> RiskFactor? {
        factors.first { $0.category == category }
    }

    public static var totalWeight: Double {
        factors.reduce(0) { $0 + $1.baseWeight }
    }
}
