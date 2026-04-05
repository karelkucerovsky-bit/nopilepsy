import Foundation
import SwiftData

@Model
public final class SeizureLogEntity {
    @Attribute(.unique) public var id: UUID
    public var timestamp: Date
    public var typeRaw: String?
    public var durationSeconds: Int?
    public var notes: String?
    public var preSeizureRiskScore: Double?

    public var profile: UserProfileEntity?

    public init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        typeRaw: String? = nil,
        durationSeconds: Int? = nil,
        notes: String? = nil,
        preSeizureRiskScore: Double? = nil
    ) {
        self.id = id
        self.timestamp = timestamp
        self.typeRaw = typeRaw
        self.durationSeconds = durationSeconds
        self.notes = notes
        self.preSeizureRiskScore = preSeizureRiskScore
    }
}
