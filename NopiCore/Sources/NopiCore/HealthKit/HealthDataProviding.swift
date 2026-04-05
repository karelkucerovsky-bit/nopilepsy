import Foundation

public protocol HealthDataProviding: Sendable {
    func requestAuthorization() async throws
    func fetchLatestSnapshot() async throws -> HealthSnapshot
    func getSensorAvailability() -> SensorAvailability
    func enableBackgroundDelivery() async throws
}
