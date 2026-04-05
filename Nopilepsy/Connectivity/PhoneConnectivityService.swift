import Foundation
import WatchConnectivity
import SwiftData
import NopiCore

final class PhoneConnectivityService: NSObject, WCSessionDelegate, @unchecked Sendable {
    static let shared = PhoneConnectivityService()
    private var modelContext: ModelContext?

    func setup(modelContext: ModelContext) {
        self.modelContext = modelContext
        guard WCSession.isSupported() else { return }
        WCSession.default.delegate = self
        WCSession.default.activate()
    }

    // MARK: - Send profile updates to Watch

    func sendProfileUpdate(_ profile: UserProfileEntity) {
        guard WCSession.default.isReachable else { return }

        var context: [String: Any] = [:]
        if let seizureType = profile.seizureType {
            context["seizureType"] = seizureType
        }

        let meds = profile.medications.filter(\.isActive).map { med in
            ["name": med.name, "dosageMg": med.dosageMg, "timesPerDay": med.timesPerDay] as [String: Any]
        }
        context["medications"] = meds

        let triggers = profile.triggers.filter(\.isActive).map(\.name)
        context["triggers"] = triggers

        try? WCSession.default.updateApplicationContext(context)
    }

    // MARK: - WCSessionDelegate

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // Ready
    }

    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }

    // Receive risk assessments from Watch
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        guard let modelContext else { return }

        guard let scoreVal = userInfo["score"] as? Double,
              let levelRaw = userInfo["level"] as? String,
              let confidence = userInfo["confidence"] as? Double,
              let timestamp = userInfo["timestamp"] as? Date else { return }

        let level = RiskLevel(rawValue: levelRaw) ?? .low
        let entity = RiskAssessmentEntity(
            timestamp: timestamp,
            level: level,
            score: scoreVal,
            confidence: confidence,
            baselineCalibrated: userInfo["baselineCalibrated"] as? Bool ?? false
        )
        modelContext.insert(entity)
        try? modelContext.save()
    }
}
