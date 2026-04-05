import Foundation
import NopiCore

final class MockBaselineLearning: BaselineLearning, @unchecked Sendable {
    var mockBaseline: BaselineModel?
    var mockProgress: CalibrationProgress
    var updateCount = 0

    init(
        baseline: BaselineModel? = nil,
        progress: CalibrationProgress = CalibrationProgress()
    ) {
        self.mockBaseline = baseline
        self.mockProgress = progress
    }

    func getBaseline() -> BaselineModel? {
        mockBaseline
    }

    func getCalibrationProgress() -> CalibrationProgress {
        mockProgress
    }

    func updateBaseline(with snapshot: HealthSnapshot) {
        updateCount += 1
    }

    func reset() {
        mockBaseline = nil
        updateCount = 0
    }
}
