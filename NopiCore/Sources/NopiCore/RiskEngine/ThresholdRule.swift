import Foundation

public protocol ThresholdRule: Sendable {
    func evaluate(snapshot: HealthSnapshot) -> Double?
}
