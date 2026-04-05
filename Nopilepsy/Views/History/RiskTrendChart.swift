import SwiftUI
import Charts
import NopiCore

struct RiskTrendChart: View {
    let data: [(date: Date, score: Double)]

    var body: some View {
        Chart {
            // Color zone backgrounds
            RectangleMark(yStart: .value("", 0), yEnd: .value("", 25))
                .foregroundStyle(.green.opacity(0.05))
            RectangleMark(yStart: .value("", 25), yEnd: .value("", 50))
                .foregroundStyle(.yellow.opacity(0.05))
            RectangleMark(yStart: .value("", 50), yEnd: .value("", 75))
                .foregroundStyle(.orange.opacity(0.05))
            RectangleMark(yStart: .value("", 75), yEnd: .value("", 100))
                .foregroundStyle(.red.opacity(0.05))

            // Data line
            ForEach(data.indices, id: \.self) { index in
                LineMark(
                    x: .value("Date", data[index].date),
                    y: .value("Score", data[index].score)
                )
                .foregroundStyle(.blue)
                .interpolationMethod(.catmullRom)
                .lineStyle(StrokeStyle(lineWidth: 2))

                PointMark(
                    x: .value("Date", data[index].date),
                    y: .value("Score", data[index].score)
                )
                .foregroundStyle(pointColor(for: data[index].score))
                .symbolSize(20)
            }
        }
        .chartYScale(domain: 0...100)
        .chartYAxis {
            AxisMarks(values: [0, 25, 50, 75, 100]) { value in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [4]))
                AxisValueLabel {
                    if let v = value.as(Int.self) {
                        Text("\(v)")
                            .font(.caption2)
                    }
                }
            }
        }
        .chartXAxis {
            AxisMarks { value in
                AxisGridLine()
                AxisValueLabel(format: .dateTime.day().month(.abbreviated))
            }
        }
    }

    private func pointColor(for score: Double) -> Color {
        switch score {
        case ..<25: .green
        case 25..<50: .yellow
        case 50..<75: .orange
        default: .red
        }
    }
}
