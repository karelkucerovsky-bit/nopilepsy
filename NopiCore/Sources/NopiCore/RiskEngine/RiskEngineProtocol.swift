import Foundation

public protocol RiskEngineProtocol: Sendable {
    func calculateRisk(
        snapshot: HealthSnapshot,
        baseline: BaselineModel?,
        medicationAdherence: Double?
    ) -> RiskAssessment
}
