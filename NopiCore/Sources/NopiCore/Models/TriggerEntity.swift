import Foundation
import SwiftData

@Model
public final class TriggerEntity {
    @Attribute(.unique) public var id: UUID
    public var name: String
    public var isActive: Bool

    public var profile: UserProfileEntity?

    public init(
        id: UUID = UUID(),
        name: String,
        isActive: Bool = true
    ) {
        self.id = id
        self.name = name
        self.isActive = isActive
    }
}
