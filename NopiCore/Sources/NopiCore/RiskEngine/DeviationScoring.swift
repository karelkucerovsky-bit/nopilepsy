import Foundation

public enum DeviationScoring {
    /// Maps a z-score to a 0-1 risk score using a sigmoid function.
    /// z=0 -> ~0.12 (low risk), z=2 -> ~0.5 (moderate), z=3+ -> high
    public static func sigmoidScore(zScore: Double, sensitivity: Double = 1.5) -> Double {
        let absZ = abs(zScore)
        return 1.0 / (1.0 + exp(-absZ * sensitivity + 2.0))
    }

    /// Computes z-score from current value, baseline mean, and standard deviation.
    /// Returns nil if standard deviation is too small (insufficient data).
    public static func zScore(current: Double, mean: Double, standardDeviation: Double) -> Double? {
        guard standardDeviation > 0.001 else { return nil }
        return (current - mean) / standardDeviation
    }

    /// Full deviation evaluation: current value vs baseline -> sigmoid risk score.
    public static func evaluate(current: Double, mean: Double, standardDeviation: Double, sensitivity: Double = 1.5) -> Double? {
        guard let z = zScore(current: current, mean: mean, standardDeviation: standardDeviation) else {
            return nil
        }
        return sigmoidScore(zScore: z, sensitivity: sensitivity)
    }
}
