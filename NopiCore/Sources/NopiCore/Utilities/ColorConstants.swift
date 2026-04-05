import SwiftUI

public extension RiskLevel {
    var color: Color {
        switch self {
        case .low: .green
        case .moderate: .yellow
        case .elevated: .orange
        case .high: .red
        }
    }

    var backgroundColor: Color {
        switch self {
        case .low: Color.green.opacity(0.15)
        case .moderate: Color.yellow.opacity(0.15)
        case .elevated: Color.orange.opacity(0.15)
        case .high: Color.red.opacity(0.15)
        }
    }

    var gradient: LinearGradient {
        switch self {
        case .low:
            LinearGradient(colors: [.green.opacity(0.6), .green], startPoint: .top, endPoint: .bottom)
        case .moderate:
            LinearGradient(colors: [.yellow.opacity(0.6), .yellow], startPoint: .top, endPoint: .bottom)
        case .elevated:
            LinearGradient(colors: [.orange.opacity(0.6), .orange], startPoint: .top, endPoint: .bottom)
        case .high:
            LinearGradient(colors: [.red.opacity(0.6), .red], startPoint: .top, endPoint: .bottom)
        }
    }
}
