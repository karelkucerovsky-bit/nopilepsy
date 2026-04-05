import Foundation

public protocol BaselineLearning: Sendable {
    func getBaseline() -> BaselineModel?
    func getCalibrationProgress() -> CalibrationProgress
    func updateBaseline(with snapshot: HealthSnapshot)
    func reset()
}
