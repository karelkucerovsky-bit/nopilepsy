import Foundation
import SwiftData

@Model
public final class MedicationLogEntity {
    @Attribute(.unique) public var id: UUID
    public var timestamp: Date
    public var taken: Bool
    public var notes: String?

    public var medication: MedicationEntity?

    public init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        taken: Bool = true,
        notes: String? = nil
    ) {
        self.id = id
        self.timestamp = timestamp
        self.taken = taken
        self.notes = notes
    }
}
