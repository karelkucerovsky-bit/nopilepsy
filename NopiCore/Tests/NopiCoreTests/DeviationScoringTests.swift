import Testing
@testable import NopiCore

@Suite("DeviationScoring")
struct DeviationScoringTests {

    @Test("Z-score of 0 gives low risk")
    func zScoreZero() {
        let score = DeviationScoring.sigmoidScore(zScore: 0)
        #expect(score < 0.2)
    }

    @Test("Z-score of 2 gives moderate risk")
    func zScoreTwo() {
        let score = DeviationScoring.sigmoidScore(zScore: 2)
        #expect(score >= 0.4)
        #expect(score <= 0.7)
    }

    @Test("Z-score of 4 gives high risk")
    func zScoreFour() {
        let score = DeviationScoring.sigmoidScore(zScore: 4)
        #expect(score > 0.8)
    }

    @Test("Negative z-score uses absolute value")
    func negativeZScore() {
        let positive = DeviationScoring.sigmoidScore(zScore: 2)
        let negative = DeviationScoring.sigmoidScore(zScore: -2)
        #expect(positive == negative)
    }

    @Test("Z-score calculation with valid SD")
    func zScoreCalc() {
        let z = DeviationScoring.zScore(current: 50, mean: 40, standardDeviation: 5)
        #expect(z == 2.0)
    }

    @Test("Z-score returns nil for tiny SD")
    func zScoreTinySD() {
        let z = DeviationScoring.zScore(current: 50, mean: 50, standardDeviation: 0.0001)
        #expect(z == nil)
    }

    @Test("Full evaluation pipeline")
    func fullEvaluation() {
        let score = DeviationScoring.evaluate(current: 50, mean: 40, standardDeviation: 5)
        #expect(score != nil)
        #expect(score! >= 0.4)
    }
}
