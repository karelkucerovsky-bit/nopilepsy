import Foundation
import SwiftData

@Model
public final class BaselineModelEntity {
    @Attribute(.unique) public var id: UUID
    public var lastUpdated: Date
    public var daysCollected: Int
    public var metricsJSON: Data

    public init(
        id: UUID = UUID(),
        lastUpdated: Date = Date(),
        daysCollected: Int = 0,
        metricsJSON: Data = Data()
    ) {
        self.id = id
        self.lastUpdated = lastUpdated
        self.daysCollected = daysCollected
        self.metricsJSON = metricsJSON
    }
}
