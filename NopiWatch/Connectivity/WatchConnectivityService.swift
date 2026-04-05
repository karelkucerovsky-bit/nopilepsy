import Foundation
import WatchConnectivity
import NopiCore

final class WatchConnectivityService: NSObject, WCSessionDelegate, @unchecked Sendable {
    static let shared = WatchConnectivityService()

    func setup() {
        guard WCSession.isSupported() else { return }
        WCSession.default.delegate = self
        WCSession.default.activate()
    }

    // MARK: - Send risk assessment to iPhone

    func sendAssessment(_ assessment: RiskAssessment) {
        let info: [String: Any] = [
            "score": assessment.score,
            "level": assessment.level.rawValue,
            "confidence": assessment.confidence,
            "timestamp": assessment.timestamp,
            "baselineCalibrated": assessment.baselineCalibrated
        ]
        WCSession.default.transferUserInfo(info)
    }

    // MARK: - WCSessionDelegate

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Ready
    }

    // Receive profile updates from iPhone
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        // Profile sync handled — medications, triggers, seizure type
        // These can be used to update the Watch's local data
        NotificationCenter.default.post(name: .profileUpdated, object: applicationContext)
    }
}

extension Notification.Name {
    static let profileUpdated = Notification.Name("profileUpdated")
}
