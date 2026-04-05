import SwiftUI
import NopiCore

struct RiskCircleView: View {
    let score: Double
    let level: RiskLevel
    let confidence: Double

    var body: some View {
        ZStack {
            // Outer ring background
            Circle()
                .stroke(lineWidth: 16)
                .foregroundStyle(.gray.opacity(0.1))

            // Risk ring
            Circle()
                .trim(from: 0, to: min(score / 100, 1.0))
                .stroke(
                    AngularGradient(
                        gradient: Gradient(colors: [level.color.opacity(0.5), level.color]),
                        center: .center,
                        startAngle: .degrees(-90),
                        endAngle: .degrees(270)
                    ),
                    style: StrokeStyle(lineWidth: 16, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.0), value: score)

            // Center content
            VStack(spacing: 4) {
                Text("\(Int(score))")
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundStyle(level.color)

                Text(level.displayName)
                    .font(.title3.weight(.medium))
                    .foregroundStyle(.secondary)

                // Confidence indicator
                HStack(spacing: 4) {
                    Image(systemName: "sensor.fill")
                        .font(.caption2)
                    Text("\(Int(confidence * 100))% sensor coverage")
                        .font(.caption2)
                }
                .foregroundStyle(.tertiary)
            }
        }
        .padding(24)
    }
}
