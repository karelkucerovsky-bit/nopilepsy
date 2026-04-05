import SwiftUI
import NopiCore

struct WatchCalibrationView: View {
    let progress: CalibrationProgress

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Progress ring
                ZStack {
                    Circle()
                        .stroke(lineWidth: 8)
                        .foregroundStyle(.gray.opacity(0.2))

                    Circle()
                        .trim(from: 0, to: progress.progress)
                        .stroke(
                            .blue,
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .rotationEffect(.degrees(-90))

                    VStack {
                        Text("Day \(progress.daysCollected)")
                            .font(.title3.bold())
                        Text("of \(progress.minimumDays)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(width: 100, height: 100)

                Text("Learning your baseline patterns")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                // Metric readiness
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(FactorCategory.allCases, id: \.self) { category in
                        if category != .medicationAdherence && category != .stressProxy {
                            HStack {
                                Image(systemName: progress.metricsReady[category] == true ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(progress.metricsReady[category] == true ? .green : .gray)
                                    .font(.caption2)
                                Text(category.displayName)
                                    .font(.caption2)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Calibrating")
    }
}
