import SwiftUI
import NopiCore

struct WatchRiskBadge: View {
    let level: RiskLevel

    var body: some View {
        Text(level.displayName)
            .font(.caption2.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(level.color.opacity(0.2))
            .foregroundStyle(level.color)
            .clipShape(Capsule())
    }
}
