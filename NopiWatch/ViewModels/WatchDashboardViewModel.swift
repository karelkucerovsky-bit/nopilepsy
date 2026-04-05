import Foundation
import SwiftData
import NopiCore

@Observable
final class WatchDashboardViewModel {
    var currentAssessment: RiskAssessment?
    var calibrationProgress: CalibrationProgress?
    var isLoading = false
    var lastUpdated: Date?
    var hasMedications = false

    private let riskEngine = RiskEngine()
    private var healthService: HealthKitService?
    private var baselineManager: BaselineManager?
    private var medicationManager: MedicationScheduleManager?

    func setup(modelContext: ModelContext) {
        healthService = HealthKitService()
        baselineManager = BaselineManager(modelContext: modelContext)
        medicationManager = MedicationScheduleManager(modelContext: modelContext)
        hasMedications = !(medicationManager?.getActiveMedications().isEmpty ?? true)
    }

    func requestPermissions() async {
        do {
            try await healthService?.requestAuthorization()
            try await healthService?.enableBackgroundDelivery()
        } catch {
            // Permissions denied — app still works with reduced confidence
        }
    }

    func refreshRisk() async {
        isLoading = true
        defer { isLoading = false }

        guard let healthService else { return }

        do {
            let snapshot = try await healthService.fetchLatestSnapshot()
            baselineManager?.updateBaseline(with: snapshot)

            let baseline = baselineManager?.getBaseline()
            let adherence = medicationManager?.calculateCurrentAdherence()

            let assessment = riskEngine.calculateRisk(
                snapshot: snapshot,
                baseline: baseline,
                medicationAdherence: adherence
            )

            currentAssessment = assessment
            calibrationProgress = baselineManager?.getCalibrationProgress()
            lastUpdated = Date()

            // Sync to iPhone
            WatchConnectivityService.shared.sendAssessment(assessment)
        } catch {
            // Keep showing last known assessment
        }
    }
}
