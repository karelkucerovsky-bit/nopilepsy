import SwiftUI
import Charts
import NopiCore

struct FactorBarChart: View {
    let factors: [FactorContribution]

    var body: some View {
        Chart(factors) { factor in
            BarMark(
                x: .value("Contribution", factor.blendedScore * 100),
                y: .value("Factor", factor.category.displayName)
            )
            .foregroundStyle(barColor(for: factor.blendedScore))
            .cornerRadius(4)
        }
        .chartXScale(domain: 0...100)
        .chartXAxis {
            AxisMarks(values: [0, 25, 50, 75, 100]) { value in
                AxisGridLine()
                AxisValueLabel {
                    if let v = value.as(Int.self) {
                        Text("\(v)")
                            .font(.caption2)
                    }
                }
            }
        }
        .chartPlotStyle { plotArea in
            plotArea.background(.clear)
        }
    }

    private func barColor(for score: Double) -> Color {
        switch score {
        case ..<0.25: .green
        case 0.25..<0.5: .yellow
        case 0.5..<0.75: .orange
        default: .red
        }
    }
}
