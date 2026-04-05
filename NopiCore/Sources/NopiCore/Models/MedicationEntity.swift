import Foundation
import SwiftData

@Model
public final class MedicationEntity {
    @Attribute(.unique) public var id: UUID
    public var name: String
    public var dosageMg: Double
    public var timesPerDay: Int
    public var scheduledTimesJSON: Data
    public var isActive: Bool

    public var profile: UserProfileEntity?

    @Relationship(deleteRule: .cascade, inverse: \MedicationLogEntity.medication)
    public var logs: [MedicationLogEntity]

    public var scheduledTimes: [DateComponents] {
        get {
            (try? JSONDecoder().decode([CodableDateComponents].self, from: scheduledTimesJSON))?.map(\.components) ?? []
        }
        set {
            scheduledTimesJSON = (try? JSONEncoder().encode(newValue.map(CodableDateComponents.init))) ?? Data()
        }
    }

    public init(
        id: UUID = UUID(),
        name: String,
        dosageMg: Double,
        timesPerDay: Int,
        scheduledTimesJSON: Data = Data(),
        isActive: Bool = true,
        logs: [MedicationLogEntity] = []
    ) {
        self.id = id
        self.name = name
        self.dosageMg = dosageMg
        self.timesPerDay = timesPerDay
        self.scheduledTimesJSON = scheduledTimesJSON
        self.isActive = isActive
        self.logs = logs
    }
}

struct CodableDateComponents: Codable {
    let hour: Int?
    let minute: Int?

    var components: DateComponents {
        var dc = DateComponents()
        dc.hour = hour
        dc.minute = minute
        return dc
    }

    init(_ dc: DateComponents) {
        self.hour = dc.hour
        self.minute = dc.minute
    }
}
