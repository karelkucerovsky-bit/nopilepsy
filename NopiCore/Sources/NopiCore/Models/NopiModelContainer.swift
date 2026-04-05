import Foundation
import SwiftData

public enum NopiModelContainer {
    public static func create() throws -> ModelContainer {
        let schema = Schema([
            RiskAssessmentEntity.self,
            FactorContributionEntity.self,
            BaselineModelEntity.self,
            UserProfileEntity.self,
            MedicationEntity.self,
            MedicationLogEntity.self,
            SeizureLogEntity.self,
            TriggerEntity.self,
            AppSettingsEntity.self
        ])
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        return try ModelContainer(for: schema, configurations: [configuration])
    }

    public static func createInMemory() throws -> ModelContainer {
        let schema = Schema([
            RiskAssessmentEntity.self,
            FactorContributionEntity.self,
            BaselineModelEntity.self,
            UserProfileEntity.self,
            MedicationEntity.self,
            MedicationLogEntity.self,
            SeizureLogEntity.self,
            TriggerEntity.self,
            AppSettingsEntity.self
        ])
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: true
        )
        return try ModelContainer(for: schema, configurations: [configuration])
    }
}
