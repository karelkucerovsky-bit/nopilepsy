import Foundation

public final class RiskEngine: RiskEngineProtocol, @unchecked Sendable {
    public static let modelVersion = "1.0.0"

    public init() {}

    public func calculateRisk(
        snapshot: HealthSnapshot,
        baseline: BaselineModel?,
        medicationAdherence: Double?
    ) -> RiskAssessment {
        let blendRatio = baseline?.calibrationProgress.blendRatio ?? 0
        var contributions: [FactorContribution] = []
        var availableWeight: Double = 0

        for factor in RiskFactorTable.factors {
            let rule = ThresholdRules.rule(for: factor.category)

            // Get threshold score
            var thresholdScore: Double?
            var rawValue: Double?

            if factor.category == .medicationAdherence {
                if let adherence = medicationAdherence {
                    thresholdScore = evaluateMedicationThreshold(adherence)
                    rawValue = adherence
                }
            } else {
                thresholdScore = rule.evaluate(snapshot: snapshot)
                rawValue = extractRawValue(for: factor.category, from: snapshot)
            }

            guard let threshold = thresholdScore else {
                // Sensor not available — skip this factor
                continue
            }

            availableWeight += factor.baseWeight

            // Get deviation score if baseline is calibrated for this metric
            var deviationScore: Double?
            var baselineValue: Double?

            if let bl = baseline, let metricBl = bl.metrics[factor.category], metricBl.isReady,
               let raw = rawValue {
                baselineValue = metricBl.ema
                deviationScore = DeviationScoring.evaluate(
                    current: raw,
                    mean: metricBl.ema,
                    standardDeviation: metricBl.standardDeviation
                )
            }

            // Blend threshold and deviation scores
            let blended: Double
            if let deviation = deviationScore {
                blended = (1.0 - blendRatio) * threshold + blendRatio * deviation
            } else {
                blended = threshold
            }

            let weighted = blended * factor.baseWeight

            contributions.append(FactorContribution(
                category: factor.category,
                rawValue: rawValue,
                baselineValue: baselineValue,
                thresholdScore: threshold,
                deviationScore: deviationScore,
                blendedScore: blended,
                weight: factor.baseWeight,
                weightedContribution: weighted,
                citationDOI: factor.citation.doi
            ))
        }

        // Calculate final score
        let totalWeighted = contributions.reduce(0) { $0 + $1.weightedContribution }
        let normalizedScore: Double
        if availableWeight > 0 {
            normalizedScore = min((totalWeighted / availableWeight) * 100, 100)
        } else {
            normalizedScore = 0
        }

        let confidence = availableWeight / RiskFactorTable.totalWeight
        let level = RiskLevel.from(score: normalizedScore)

        // Sort contributions by weighted impact (highest first)
        let sorted = contributions.sorted { $0.weightedContribution > $1.weightedContribution }

        return RiskAssessment(
            level: level,
            score: normalizedScore,
            confidence: confidence,
            factors: sorted,
            baselineCalibrated: baseline?.calibrationProgress.isCalibrated ?? false,
            modelVersion: Self.modelVersion
        )
    }

    private func evaluateMedicationThreshold(_ adherence: Double) -> Double {
        switch adherence {
        case 0.75...: return 0.0
        case 0.5..<0.75: return 0.3
        case 0.25..<0.5: return 0.6
        default: return 0.9
        }
    }

    private func extractRawValue(for category: FactorCategory, from snapshot: HealthSnapshot) -> Double? {
        switch category {
        case .sleepDuration: snapshot.sleepDurationHours
        case .sleepQuality: snapshot.sleepStages?.deepPercent
        case .hrv: snapshot.hrvMs
        case .restingHeartRate: snapshot.restingHeartRate
        case .spO2: snapshot.spO2Percent
        case .skinTemperature: snapshot.skinTempCelsius
        case .activityLevel: snapshot.activitySteps.map(Double.init)
        case .medicationAdherence: nil
        case .stressProxy: nil
        }
    }
}
