import SwiftUI
import NopiCore

struct WatchFactorRow: View {
    let factor: FactorContribution

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: factor.category.iconName)
                .font(.caption2)
                .foregroundStyle(barColor)
                .frame(width: 16)

            VStack(alignment: .leading, spacing: 2) {
                Text(factor.category.displayName)
                    .font(.caption2)
                    .lineLimit(1)

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.gray.opacity(0.2))
                            .frame(height: 4)

                        Capsule()
                            .fill(barColor)
                            .frame(width: max(geo.size.width * factor.blendedScore, 2), height: 4)
                    }
                }
                .frame(height: 4)
            }

            Text(factor.displayValue)
                .font(.system(size: 10))
                .foregroundStyle(.secondary)
                .frame(width: 40, alignment: .trailing)
        }
    }

    private var barColor: Color {
        switch factor.blendedScore {
        case ..<0.25: .green
        case 0.25..<0.5: .yellow
        case 0.5..<0.75: .orange
        default: .red
        }
    }
}
