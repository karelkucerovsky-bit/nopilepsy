import Foundation

public enum RiskLevel: String, Codable, CaseIterable, Sendable {
    case low
    case moderate
    case elevated
    case high

    public var displayName: String {
        rawValue.capitalized
    }

    public var scoreRange: ClosedRange<Double> {
        switch self {
        case .low: 0...25
        case .moderate: 26...50
        case .elevated: 51...75
        case .high: 76...100
        }
    }

    public static func from(score: Double) -> RiskLevel {
        switch score {
        case 0...25: .low
        case 26...50: .moderate
        case 51...75: .elevated
        default: .high
        }
    }
}
