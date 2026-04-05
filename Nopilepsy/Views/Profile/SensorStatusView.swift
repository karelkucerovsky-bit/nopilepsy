import SwiftUI
import NopiCore

struct SensorStatusView: View {
    let availability: SensorAvailability

    private var sensors: [(String, String, Bool)] {
        [
            ("Sleep Tracking", "bed.double.fill", availability.sleepTracking),
            ("Heart Rate Variability", "waveform.path.ecg", availability.hrv),
            ("Resting Heart Rate", "heart.fill", availability.restingHeartRate),
            ("Blood Oxygen (SpO2)", "lungs.fill", availability.spO2),
            ("Skin Temperature", "thermometer.medium", availability.skinTemperature),
            ("Step Count", "figure.walk", availability.stepCount),
            ("ECG", "waveform.path.ecg.rectangle", availability.ecg)
        ]
    }

    var body: some View {
        List {
            Section {
                ForEach(sensors, id: \.0) { name, icon, available in
                    HStack {
                        Image(systemName: icon)
                            .foregroundStyle(available ? .green : .gray)
                            .frame(width: 28)
                        Text(name)
                        Spacer()
                        Image(systemName: available ? "checkmark.circle.fill" : "xmark.circle")
                            .foregroundStyle(available ? .green : .red.opacity(0.5))
                    }
                }
            } header: {
                Text("Available Sensors")
            } footer: {
                Text("\(availability.availableCount) of \(availability.totalCount) sensors available. Missing sensors reduce confidence but don't block risk assessment.")
            }
        }
        .navigationTitle("Sensors")
    }
}
