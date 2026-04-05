import Foundation
import SwiftData

@Model
public final class UserProfileEntity {
    @Attribute(.unique) public var id: UUID
    public var seizureType: String?
    public var notes: String?
    public var createdAt: Date
    public var updatedAt: Date

    @Relationship(deleteRule: .cascade, inverse: \MedicationEntity.profile)
    public var medications: [MedicationEntity]

    @Relationship(deleteRule: .cascade, inverse: \TriggerEntity.profile)
    public var triggers: [TriggerEntity]

    @Relationship(deleteRule: .cascade, inverse: \SeizureLogEntity.profile)
    public var seizureLogs: [SeizureLogEntity]

    public init(
        id: UUID = UUID(),
        seizureType: String? = nil,
        notes: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        medications: [MedicationEntity] = [],
        triggers: [TriggerEntity] = [],
        seizureLogs: [SeizureLogEntity] = []
    ) {
        self.id = id
        self.seizureType = seizureType
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.medications = medications
        self.triggers = triggers
        self.seizureLogs = seizureLogs
    }
}
