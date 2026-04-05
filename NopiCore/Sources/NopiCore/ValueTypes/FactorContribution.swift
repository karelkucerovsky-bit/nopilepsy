import Foundation

public struct FactorContribution: Sendable, Identifiable {
    public let id: UUID
    public let category: FactorCategory
    public let rawValue: Double?
    public let baselineValue: Double?
    public let thresholdScore: Double
    public let deviationScore: Double?
    public let blendedScore: Double
    public let weight: Double
    public let weightedContribution: Double
    public let citationDOI: String

    public var displayValue: String {
        guard let raw = rawValue else { return "N/A" }
        let unit = category.unit
        switch category {
        case .sleepDuration:
            return String(format: "%.1fh", raw)
        case .activityLevel:
            return "\(Int(raw)) \(unit)"
        case .spO2, .sleepQuality:
            return String(format: "%.0f%%", raw)
        case .hrv:
            return String(format: "%.0f ms", raw)
        case .restingHeartRate:
            return String(format: "%.0f bpm", raw)
        case .skinTemperature:
            return String(format: "%.1f°C", raw)
        case .medicationAdherence, .stressProxy:
            return String(format: "%.0f%%", raw * 100)
        }
    }

    public init(
        id: UUID = UUID(),
        category: FactorCategory,
        rawValue: Double?,
        baselineValue: Double? = nil,
        thresholdScore: Double,
        deviationScore: Double? = nil,
        blendedScore: Double,
        weight: Double,
        weightedContribution: Double,
        citationDOI: String
    ) {
        self.id = id
        self.category = category
        self.rawValue = rawValue
        self.baselineValue = baselineValue
        self.thresholdScore = thresholdScore
        self.deviationScore = deviationScore
        self.blendedScore = blendedScore
        self.weight = weight
        self.weightedContribution = weightedContribution
        self.citationDOI = citationDOI
    }
}
