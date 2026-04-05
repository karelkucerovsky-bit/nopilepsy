import Foundation

public struct CSVExporter: ExportProviding {
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return f
    }()

    public init() {}

    public func generateCSV(from assessments: [RiskAssessmentEntity]) -> String {
        var lines: [String] = []

        // Header
        lines.append("Date,Time,Risk Level,Score,Confidence,Baseline Calibrated,Top Factor 1,Top Factor 2,Top Factor 3")

        // Rows
        for assessment in assessments.sorted(by: { $0.timestamp > $1.timestamp }) {
            let date = dateFormatter.string(from: assessment.timestamp)
            let parts = date.split(separator: " ")
            let datePart = parts.first ?? ""
            let timePart = parts.last ?? ""

            let sortedFactors = assessment.factors.sorted { $0.weightedContribution > $1.weightedContribution }
            let top3 = sortedFactors.prefix(3).map { factor in
                "\(factor.displayName): \(String(format: "%.1f", factor.blendedScore * 100))%"
            }

            let row = [
                String(datePart),
                String(timePart),
                assessment.level.displayName,
                String(format: "%.1f", assessment.score),
                String(format: "%.0f%%", assessment.confidence * 100),
                assessment.baselineCalibrated ? "Yes" : "No",
                top3.count > 0 ? top3[0] : "",
                top3.count > 1 ? top3[1] : "",
                top3.count > 2 ? top3[2] : ""
            ]
            lines.append(row.map { escapeCSV($0) }.joined(separator: ","))
        }

        return lines.joined(separator: "\n")
    }

    public func generateDetailedCSV(from assessments: [RiskAssessmentEntity]) -> String {
        var lines: [String] = []

        // Header with all factor columns
        var header = ["Date", "Time", "Risk Level", "Score", "Confidence"]
        for category in FactorCategory.allCases {
            header.append("\(category.displayName) Value")
            header.append("\(category.displayName) Score")
        }
        lines.append(header.joined(separator: ","))

        for assessment in assessments.sorted(by: { $0.timestamp > $1.timestamp }) {
            let date = dateFormatter.string(from: assessment.timestamp)
            let parts = date.split(separator: " ")

            var row = [
                String(parts.first ?? ""),
                String(parts.last ?? ""),
                assessment.level.displayName,
                String(format: "%.1f", assessment.score),
                String(format: "%.0f%%", assessment.confidence * 100)
            ]

            for category in FactorCategory.allCases {
                if let factor = assessment.factors.first(where: { $0.categoryRaw == category.rawValue }) {
                    row.append(factor.rawValue.map { String(format: "%.2f", $0) } ?? "")
                    row.append(String(format: "%.3f", factor.blendedScore))
                } else {
                    row.append("")
                    row.append("")
                }
            }

            lines.append(row.map { escapeCSV($0) }.joined(separator: ","))
        }

        return lines.joined(separator: "\n")
    }

    private func escapeCSV(_ value: String) -> String {
        if value.contains(",") || value.contains("\"") || value.contains("\n") {
            return "\"\(value.replacingOccurrences(of: "\"", with: "\"\""))\""
        }
        return value
    }
}
