import Foundation
import SwiftData
import UserNotifications
import NopiCore

@Observable
final class SettingsViewModel {
    var settings: AppSettingsEntity?
    var baselineManager: BaselineManager?

    func setup(modelContext: ModelContext) {
        baselineManager = BaselineManager(modelContext: modelContext)
        loadSettings(modelContext: modelContext)
    }

    func loadSettings(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<AppSettingsEntity>()
        settings = try? modelContext.fetch(descriptor).first

        if settings == nil {
            let newSettings = AppSettingsEntity()
            modelContext.insert(newSettings)
            try? modelContext.save()
            settings = newSettings
        }
    }

    func toggleNotifications(_ enabled: Bool, modelContext: ModelContext) async {
        if enabled {
            let center = UNUserNotificationCenter.current()
            let granted = try? await center.requestAuthorization(options: [.alert, .sound])
            settings?.notificationsEnabled = granted ?? false
        } else {
            settings?.notificationsEnabled = false
        }
        try? modelContext.save()
    }

    func updateThreshold(_ level: RiskLevel, modelContext: ModelContext) {
        settings?.notificationThreshold = level
        try? modelContext.save()
    }

    func updateRetentionDays(_ days: Int, modelContext: ModelContext) {
        settings?.dataRetentionDays = days
        try? modelContext.save()
    }

    func resetBaseline(modelContext: ModelContext) {
        baselineManager?.reset()
    }
}
