import Foundation
import SwiftData
import NopiCore

@Observable
final class OnboardingViewModel {
    var currentPage = 0
    var hasScrolledDisclaimer = false
    var healthKitAuthorized = false

    private var healthService: HealthKitService?

    func setup() {
        healthService = HealthKitService()
    }

    func requestHealthKit() async {
        do {
            try await healthService?.requestAuthorization()
            healthKitAuthorized = true
        } catch {
            // User can still proceed
        }
    }

    func acceptDisclaimer(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<AppSettingsEntity>()
        let settings: AppSettingsEntity

        if let existing = try? modelContext.fetch(descriptor).first {
            settings = existing
        } else {
            settings = AppSettingsEntity()
            modelContext.insert(settings)
        }

        settings.hasAcceptedDisclaimer = true
        settings.disclaimerAcceptedAt = Date()
        try? modelContext.save()
    }
}
