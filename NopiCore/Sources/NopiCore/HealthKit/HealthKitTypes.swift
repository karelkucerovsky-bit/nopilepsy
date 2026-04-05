import HealthKit

public enum HealthKitTypes {
    public static let readTypes: Set<HKObjectType> = {
        var types: Set<HKObjectType> = [
            HKQuantityType(.heartRate),
            HKQuantityType(.restingHeartRate),
            HKQuantityType(.heartRateVariabilitySDNN),
            HKQuantityType(.oxygenSaturation),
            HKQuantityType(.stepCount),
            HKCategoryType(.sleepAnalysis)
        ]

        // Apple Watch Series 7+ temperature
        if #available(iOS 17.0, watchOS 10.0, *) {
            types.insert(HKQuantityType(.appleSleepingWristTemperature))
        }

        // ECG
        types.insert(HKObjectType.electrocardiogramType())

        return types
    }()

    public static let backgroundDeliveryTypes: [HKObjectType] = [
        HKQuantityType(.heartRate),
        HKQuantityType(.restingHeartRate),
        HKQuantityType(.heartRateVariabilitySDNN),
        HKQuantityType(.oxygenSaturation),
        HKQuantityType(.stepCount),
        HKCategoryType(.sleepAnalysis)
    ]
}
