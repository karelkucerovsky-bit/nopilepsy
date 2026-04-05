import SwiftUI
import NopiCore

struct CalibrationBanner: View {
    let progress: CalibrationProgress
    @State private var isDismissed = false

    var body: some View {
        if !isDismissed {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 3)
                        .foregroundStyle(.blue.opacity(0.2))
                        .frame(width: 36, height: 36)

                    Circle()
                        .trim(from: 0, to: progress.progress)
                        .stroke(.blue, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .frame(width: 36, height: 36)
                        .rotationEffect(.degrees(-90))

                    Text("\(progress.daysCollected)")
                        .font(.caption.bold())
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Learning Your Baseline")
                        .font(.subheadline.weight(.medium))
                    Text("Day \(progress.daysCollected) of \(progress.minimumDays) — Risk assessment improves as we learn your patterns")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if progress.isCalibrated {
                    Button {
                        withAnimation { isDismissed = true }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
            .background(.blue.opacity(0.08))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}
