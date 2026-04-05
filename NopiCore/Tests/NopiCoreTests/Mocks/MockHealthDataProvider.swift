import Foundation
import NopiCore

final class MockHealthDataProvider: HealthDataProviding, @unchecked Sendable {
    var mockSnapshot: HealthSnapshot
    var mockAvailability: SensorAvailability

    init(
        snapshot: HealthSnapshot = HealthSnapshot(),
        availability: SensorAvailability = .allAvailable
    ) {
        self.mockSnapshot = snapshot
        self.mockAvailability = availability
    }

    func requestAuthorization() async throws {}
    func enableBackgroundDelivery() async throws {}

    func fetchLatestSnapshot() async throws -> HealthSnapshot {
        mockSnapshot
    }

    func getSensorAvailability() -> SensorAvailability {
        mockAvailability
    }
}
