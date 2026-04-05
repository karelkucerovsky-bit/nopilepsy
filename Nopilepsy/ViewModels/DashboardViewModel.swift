import Foundation
import SwiftData
import NopiCore

@Observable
final class DashboardViewModel {
    var currentAssessment: RiskAssessment?
    var calibrationProgress: CalibrationProgress?
    var isLoading = false
    var lastUpdated: Date?

    private let riskEngine = RiskEngine()
    private var healthService: HealthKitService?
    private var baselineManager: BaselineManager?
    private var medicationManager: MedicationScheduleManager?

    func setup(modelContext: ModelContext) {
        healthService = HealthKitService()
        baselineManager = BaselineManager(modelContext: modelContext)
        medicationManager = MedicationScheduleManager(modelContext: modelContext)
    }

    func requestPermissions() async {
        do {
            try await healthService?.requestAuthorization()
            try await healthService?.enableBackgroundDelivery()
        } catch {
            // App works with reduced confidence
        }
    }

    func refreshRisk(modelContext: ModelContext) async {
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

            // Persist assessment
            let entity = RiskAssessmentEntity(from: assessment)
            modelContext.insert(entity)
            for factor in assessment.factors {
                let factorEntity = FactorContributionEntity(from: factor)
                factorEntity.assessment = entity
                modelContext.insert(factorEntity)
            }
            try? modelContext.save()
        } catch {
            // Keep showing last known assessment
        }
    }
}
