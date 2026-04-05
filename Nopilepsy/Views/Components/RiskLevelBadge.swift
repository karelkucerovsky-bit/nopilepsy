import SwiftUI
import NopiCore

struct RiskLevelBadge: View {
    let level: RiskLevel

    var body: some View {
        Text(level.displayName)
            .font(.caption.bold())
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(level.backgroundColor)
            .foregroundStyle(level.color)
            .clipShape(Capsule())
    }
}
