import Foundation

public enum HealthKitError: Error, LocalizedError {
    case notAvailable
    case authorizationDenied
    case noData
    case queryFailed(Error)

    public var errorDescription: String? {
        switch self {
        case .notAvailable:
            "HealthKit is not available on this device."
        case .authorizationDenied:
            "HealthKit access was denied. Please enable access in Settings."
        case .noData:
            "No health data available for the requested type."
        case .queryFailed(let error):
            "Health data query failed: \(error.localizedDescription)"
        }
    }
}
