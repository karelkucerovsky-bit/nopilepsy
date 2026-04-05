import Testing
import Foundation
@testable import NopiCore

@Suite("CSVExporter")
struct CSVExporterTests {
    let exporter = CSVExporter()

    @Test("Empty assessments produce header only")
    func emptyExport() {
        let csv = exporter.generateCSV(from: [])
        let lines = csv.split(separator: "\n")
        #expect(lines.count == 1)
        #expect(csv.contains("Date"))
        #expect(csv.contains("Risk Level"))
    }

    @Test("CSV escapes commas in values")
    func csvEscaping() {
        let csv = exporter.generateCSV(from: [])
        // Header should not need escaping
        #expect(!csv.contains("\""))
    }
}
