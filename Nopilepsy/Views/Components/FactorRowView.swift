import SwiftUI
import NopiCore

struct FactorRowView: View {
    let factor: FactorContribution

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: factor.category.iconName)
                .font(.title3)
                .foregroundStyle(scoreColor)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(factor.category.displayName)
                        .font(.subheadline.weight(.medium))
                    Spacer()
                    Text(factor.displayValue)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.gray.opacity(0.15))
                            .frame(height: 6)

                        Capsule()
                            .fill(scoreColor)
                            .frame(width: max(geo.size.width * factor.blendedScore, 4), height: 6)
                            .animation(.easeInOut(duration: 0.5), value: factor.blendedScore)
                    }
                }
                .frame(height: 6)
            }
        }
        .padding(.vertical, 4)
    }

    private var scoreColor: Color {
        switch factor.blendedScore {
        case ..<0.25: .green
        case 0.25..<0.5: .yellow
        case 0.5..<0.75: .orange
        default: .red
        }
    }
}
