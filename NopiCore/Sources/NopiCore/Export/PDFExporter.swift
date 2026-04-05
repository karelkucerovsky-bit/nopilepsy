#if canImport(UIKit)
import UIKit
import Foundation

public final class PDFExporter: @unchecked Sendable {
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm"
        return f
    }()

    private let shortDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        return f
    }()

    public init() {}

    public func generatePDF(
        from assessments: [RiskAssessmentEntity],
        profile: UserProfileEntity?,
        dateRange: ClosedRange<Date>
    ) -> Data {
        let pageWidth: CGFloat = 612  // US Letter
        let pageHeight: CGFloat = 792
        let margin: CGFloat = 50
        let contentWidth = pageWidth - margin * 2

        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight))

        return renderer.pdfData { context in
            context.beginPage()
            var y: CGFloat = margin

            // Title
            let titleAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 24),
                .foregroundColor: UIColor.black
            ]
            let title = "Nopilepsy Risk Report"
            title.draw(at: CGPoint(x: margin, y: y), withAttributes: titleAttrs)
            y += 35

            // Subtitle
            let subtitleAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.darkGray
            ]
            let dateRangeStr = "\(shortDateFormatter.string(from: dateRange.lowerBound)) — \(shortDateFormatter.string(from: dateRange.upperBound))"
            dateRangeStr.draw(at: CGPoint(x: margin, y: y), withAttributes: subtitleAttrs)
            y += 25

            // Disclaimer
            let disclaimerAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.italicSystemFont(ofSize: 9),
                .foregroundColor: UIColor.gray
            ]
            let disclaimer = "This report is for informational purposes only and is not a medical device or diagnostic tool."
            let disclaimerRect = CGRect(x: margin, y: y, width: contentWidth, height: 30)
            disclaimer.draw(in: disclaimerRect, withAttributes: disclaimerAttrs)
            y += 35

            // Separator
            drawLine(context: context.cgContext, from: CGPoint(x: margin, y: y), to: CGPoint(x: pageWidth - margin, y: y))
            y += 15

            // Profile summary (if available)
            if let profile {
                let sectionAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 14),
                    .foregroundColor: UIColor.black
                ]
                "Patient Profile".draw(at: CGPoint(x: margin, y: y), withAttributes: sectionAttrs)
                y += 22

                let bodyAttrs: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 11),
                    .foregroundColor: UIColor.darkGray
                ]

                if let seizureType = profile.seizureType {
                    "Seizure Type: \(seizureType)".draw(at: CGPoint(x: margin, y: y), withAttributes: bodyAttrs)
                    y += 18
                }

                let medNames = profile.medications.filter { $0.isActive }.map { "\($0.name) \($0.dosageMg)mg" }
                if !medNames.isEmpty {
                    "Medications: \(medNames.joined(separator: ", "))".draw(at: CGPoint(x: margin, y: y), withAttributes: bodyAttrs)
                    y += 18
                }

                y += 10
                drawLine(context: context.cgContext, from: CGPoint(x: margin, y: y), to: CGPoint(x: pageWidth - margin, y: y))
                y += 15
            }

            // Summary statistics
            let sorted = assessments.sorted { $0.timestamp < $1.timestamp }
            let scores = sorted.map(\.score)
            let avgScore = scores.isEmpty ? 0 : scores.reduce(0, +) / Double(scores.count)
            let maxScore = scores.max() ?? 0
            let minScore = scores.min() ?? 0

            let sectionAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 14)
            ]
            "Summary".draw(at: CGPoint(x: margin, y: y), withAttributes: sectionAttrs)
            y += 22

            let bodyAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 11),
                .foregroundColor: UIColor.darkGray
            ]
            "Total Assessments: \(assessments.count)".draw(at: CGPoint(x: margin, y: y), withAttributes: bodyAttrs)
            y += 18
            "Average Risk Score: \(String(format: "%.1f", avgScore))".draw(at: CGPoint(x: margin, y: y), withAttributes: bodyAttrs)
            y += 18
            "Score Range: \(String(format: "%.1f", minScore)) — \(String(format: "%.1f", maxScore))".draw(at: CGPoint(x: margin, y: y), withAttributes: bodyAttrs)
            y += 25

            drawLine(context: context.cgContext, from: CGPoint(x: margin, y: y), to: CGPoint(x: pageWidth - margin, y: y))
            y += 15

            // Assessment table
            "Assessment History".draw(at: CGPoint(x: margin, y: y), withAttributes: sectionAttrs)
            y += 22

            // Table header
            let headerAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 10),
                .foregroundColor: UIColor.darkGray
            ]
            let colWidths: [CGFloat] = [130, 70, 60, 70, contentWidth - 330]
            let headers = ["Date", "Level", "Score", "Confidence", "Top Factor"]

            var x = margin
            for (i, header) in headers.enumerated() {
                header.draw(at: CGPoint(x: x, y: y), withAttributes: headerAttrs)
                x += colWidths[i]
            }
            y += 18

            let rowAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 10)
            ]

            for assessment in sorted.suffix(50) {  // Last 50 assessments
                if y > pageHeight - margin - 30 {
                    context.beginPage()
                    y = margin
                }

                x = margin
                let values = [
                    dateFormatter.string(from: assessment.timestamp),
                    assessment.level.displayName,
                    String(format: "%.0f", assessment.score),
                    String(format: "%.0f%%", assessment.confidence * 100),
                    assessment.factors.sorted(by: { $0.weightedContribution > $1.weightedContribution }).first?.displayName ?? "—"
                ]

                for (i, value) in values.enumerated() {
                    value.draw(at: CGPoint(x: x, y: y), withAttributes: rowAttrs)
                    x += colWidths[i]
                }
                y += 16
            }

            // Footer
            y = pageHeight - margin
            let footerAttrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 8),
                .foregroundColor: UIColor.lightGray
            ]
            let footer = "Generated by Nopilepsy — Not a medical device — \(shortDateFormatter.string(from: Date()))"
            footer.draw(at: CGPoint(x: margin, y: y), withAttributes: footerAttrs)
        }
    }

    private func drawLine(context: CGContext, from: CGPoint, to: CGPoint) {
        context.setStrokeColor(UIColor.lightGray.cgColor)
        context.setLineWidth(0.5)
        context.move(to: from)
        context.addLine(to: to)
        context.strokePath()
    }
}
#endif
