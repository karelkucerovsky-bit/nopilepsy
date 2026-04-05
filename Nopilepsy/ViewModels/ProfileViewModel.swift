import Foundation
import SwiftData
import NopiCore

@Observable
final class ProfileViewModel {
    var profile: UserProfileEntity?
    var sensorAvailability = SensorAvailability()

    private var healthService: HealthKitService?

    func setup(modelContext: ModelContext) {
        healthService = HealthKitService()
        sensorAvailability = healthService?.getSensorAvailability() ?? SensorAvailability()
        loadProfile(modelContext: modelContext)
    }

    func loadProfile(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<UserProfileEntity>()
        profile = try? modelContext.fetch(descriptor).first
    }

    func createProfileIfNeeded(modelContext: ModelContext) {
        guard profile == nil else { return }
        let newProfile = UserProfileEntity()
        modelContext.insert(newProfile)
        try? modelContext.save()
        profile = newProfile
    }

    func updateSeizureType(_ type: String?, modelContext: ModelContext) {
        createProfileIfNeeded(modelContext: modelContext)
        profile?.seizureType = type
        profile?.updatedAt = Date()
        try? modelContext.save()
    }

    func addTrigger(_ name: String, modelContext: ModelContext) {
        createProfileIfNeeded(modelContext: modelContext)
        let trigger = TriggerEntity(name: name)
        trigger.profile = profile
        modelContext.insert(trigger)
        try? modelContext.save()
    }

    func removeTrigger(_ trigger: TriggerEntity, modelContext: ModelContext) {
        modelContext.delete(trigger)
        try? modelContext.save()
    }
}
