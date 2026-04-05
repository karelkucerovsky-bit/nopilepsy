import Foundation
import SwiftData
import NopiCore

@Observable
final class ExportViewModel {
    var startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
    var endDate = Date()
    var exportFormat: ExportFormat = .pdf
    var isExporting = false
    var exportedFileURL: URL?

    enum ExportFormat: String, CaseIterable {
        case pdf = "PDF"
        case csv = "CSV"
    }

    func generateExport(assessments: [RiskAssessmentEntity], profile: UserProfileEntity?) -> URL? {
        isExporting = true
        defer { isExporting = false }

        let filtered = assessments.filter { $0.timestamp >= startDate && $0.timestamp <= endDate }
        let tempDir = FileManager.default.temporaryDirectory

        switch exportFormat {
        case .csv:
            let csv = CSVExporter().generateDetailedCSV(from: filtered)
            let url = tempDir.appendingPathComponent("nopilepsy-report.csv")
            try? csv.write(to: url, atomically: true, encoding: .utf8)
            exportedFileURL = url
            return url

        case .pdf:
            #if canImport(UIKit)
            let data = PDFExporter().generatePDF(
                from: filtered,
                profile: profile,
                dateRange: startDate...endDate
            )
            let url = tempDir.appendingPathComponent("nopilepsy-report.pdf")
            try? data.write(to: url)
            exportedFileURL = url
            return url
            #else
            return nil
            #endif
        }
    }
}
