import Foundation
import SwiftData

@Model
public final class AppSettingsEntity {
    @Attribute(.unique) public var id: UUID
    public var notificationsEnabled: Bool
    public var notificationThresholdRaw: String
    public var dataRetentionDays: Int
    public var hasAcceptedDisclaimer: Bool
    public var disclaimerAcceptedAt: Date?
    public var exportFormatRaw: String

    public var notificationThreshold: RiskLevel {
        get { RiskLevel(rawValue: notificationThresholdRaw) ?? .high }
        set { notificationThresholdRaw = newValue.rawValue }
    }

    public init(
        id: UUID = UUID(),
        notificationsEnabled: Bool = false,
        notificationThresholdRaw: String = RiskLevel.high.rawValue,
        dataRetentionDays: Int = 365,
        hasAcceptedDisclaimer: Bool = false,
        disclaimerAcceptedAt: Date? = nil,
        exportFormatRaw: String = "pdf"
    ) {
        self.id = id
        self.notificationsEnabled = notificationsEnabled
        self.notificationThresholdRaw = notificationThresholdRaw
        self.dataRetentionDays = dataRetentionDays
        self.hasAcceptedDisclaimer = hasAcceptedDisclaimer
        self.disclaimerAcceptedAt = disclaimerAcceptedAt
        self.exportFormatRaw = exportFormatRaw
    }
}
