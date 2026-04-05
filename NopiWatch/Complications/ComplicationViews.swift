import WidgetKit
import SwiftUI
import NopiCore

struct NopiComplicationEntry: TimelineEntry {
    let date: Date
    let score: Double
    let level: RiskLevel
    let confidence: Double
}

struct NopiComplicationProvider: TimelineProvider {
    func placeholder(in context: Context) -> NopiComplicationEntry {
        NopiComplicationEntry(date: Date(), score: 25, level: .low, confidence: 0.8)
    }

    func getSnapshot(in context: Context, completion: @escaping (NopiComplicationEntry) -> Void) {
        let entry = NopiComplicationEntry(date: Date(), score: 25, level: .low, confidence: 0.8)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<NopiComplicationEntry>) -> Void) {
        // In production, read latest assessment from shared container
        let entry = NopiComplicationEntry(date: Date(), score: 25, level: .low, confidence: 0.8)
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

// MARK: - Circular Complication

struct CircularComplicationView: View {
    let entry: NopiComplicationEntry

    var body: some View {
        ZStack {
            AccessoryWidgetBackground()

            Gauge(value: entry.score, in: 0...100) {
                Text("")
            } currentValueLabel: {
                Text("\(Int(entry.score))")
                    .font(.system(.title3, design: .rounded).bold())
            }
            .gaugeStyle(.accessoryCircular)
            .tint(entry.level.color)
        }
    }
}

// MARK: - Corner Complication

struct CornerComplicationView: View {
    let entry: NopiComplicationEntry

    var body: some View {
        Text("\(Int(entry.score))")
            .font(.system(.title3, design: .rounded).bold())
            .foregroundStyle(entry.level.color)
            .widgetLabel {
                Gauge(value: entry.score, in: 0...100) {
                    Text("Risk")
                }
                .tint(entry.level.color)
            }
    }
}

// MARK: - Inline Complication

struct InlineComplicationView: View {
    let entry: NopiComplicationEntry

    var body: some View {
        Text("Risk: \(Int(entry.score)) \(entry.level.displayName)")
    }
}

// MARK: - Widget
@main
struct NopiComplicationWidget: Widget {
    let kind = "NopiComplication"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NopiComplicationProvider()) { entry in
            CircularComplicationView(entry: entry)
        }
        .configurationDisplayName("Seizure Risk")
        .description("Current seizure risk level from Nopilepsy")
        .supportedFamilies([
            .accessoryCircular,
            .accessoryCorner,
            .accessoryInline
        ])
    }
}
