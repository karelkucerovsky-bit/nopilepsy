import Foundation

public enum FactorCategory: String, Codable, CaseIterable, Sendable {
    case sleepDuration
    case sleepQuality
    case hrv
    case restingHeartRate
    case spO2
    case skinTemperature
    case activityLevel
    case medicationAdherence
    case stressProxy

    public var displayName: String {
        switch self {
        case .sleepDuration: "Sleep Duration"
        case .sleepQuality: "Sleep Quality"
        case .hrv: "Heart Rate Variability"
        case .restingHeartRate: "Resting Heart Rate"
        case .spO2: "Blood Oxygen"
        case .skinTemperature: "Skin Temperature"
        case .activityLevel: "Activity Level"
        case .medicationAdherence: "Medication Adherence"
        case .stressProxy: "Stress Level"
        }
    }

    public var unit: String {
        switch self {
        case .sleepDuration: "hours"
        case .sleepQuality: "%"
        case .hrv: "ms"
        case .restingHeartRate: "bpm"
        case .spO2: "%"
        case .skinTemperature: "°C"
        case .activityLevel: "steps"
        case .medicationAdherence: ""
        case .stressProxy: ""
        }
    }

    public var iconName: String {
        switch self {
        case .sleepDuration, .sleepQuality: "bed.double.fill"
        case .hrv: "waveform.path.ecg"
        case .restingHeartRate: "heart.fill"
        case .spO2: "lungs.fill"
        case .skinTemperature: "thermometer.medium"
        case .activityLevel: "figure.walk"
        case .medicationAdherence: "pills.fill"
        case .stressProxy: "brain.head.profile"
        }
    }
}
