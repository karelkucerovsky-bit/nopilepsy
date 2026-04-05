import SwiftUI
import Charts

struct SparklineView: View {
    let data: [(date: Date, value: Double)]
    let color: Color

    var body: some View {
        Chart {
            ForEach(data.indices, id: \.self) { index in
                LineMark(
                    x: .value("Date", data[index].date),
                    y: .value("Value", data[index].value)
                )
                .foregroundStyle(color)
                .interpolationMethod(.catmullRom)

                AreaMark(
                    x: .value("Date", data[index].date),
                    y: .value("Value", data[index].value)
                )
                .foregroundStyle(color.opacity(0.1))
                .interpolationMethod(.catmullRom)
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartYScale(domain: 0...100)
    }
}
