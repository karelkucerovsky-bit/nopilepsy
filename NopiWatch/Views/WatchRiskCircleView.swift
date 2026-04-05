import SwiftUI
import NopiCore

struct WatchRiskCircleView: View {
    let score: Double
    let level: RiskLevel
    let confidence: Double

    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(lineWidth: 10)
                .foregroundStyle(.gray.opacity(0.2))

            // Risk ring
            Circle()
                .trim(from: 0, to: min(score / 100, 1.0))
                .stroke(
                    level.color,
                    style: StrokeStyle(lineWidth: 10, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.8), value: score)

            // Score and level
            VStack(spacing: 2) {
                Text("\(Int(score))")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(level.color)

                Text(level.displayName)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(4)
        .overlay(alignment: .bottom) {
            // Confidence bar
            ConfidenceBar(confidence: confidence)
                .frame(height: 3)
                .padding(.horizontal, 20)
        }
    }
}

struct ConfidenceBar: View {
    let confidence: Double

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(.gray.opacity(0.3))

                Capsule()
                    .fill(.blue.opacity(0.6))
                    .frame(width: geo.size.width * confidence)
            }
        }
    }
}
