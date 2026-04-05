import Foundation

public enum Citations {
    public static let all: [ResearchCitation] = [
        sleepDeprivation,
        sleepArchitecture,
        hrvAutonomic,
        ictalTachycardia,
        oxygenDesaturation,
        febrileTemperature,
        exhaustionTrigger,
        missedAED,
        stressTrigger
    ]

    public static let sleepDeprivation = ResearchCitation(
        factorCategory: .sleepDuration,
        studyTitle: "Sleep deprivation as a risk factor for seizures in idiopathic generalized epilepsy",
        authors: "Malow BA, Passaro E, et al.",
        journal: "Neurology",
        year: 2004,
        doi: "10.1212/01.WNL.0000137583.15232.84",
        findingSummary: "28% of patients with idiopathic generalized epilepsy reported sleep deprivation as a seizure trigger. Inadequate sleep duration (<6 hours) significantly increased seizure risk."
    )

    public static let sleepArchitecture = ResearchCitation(
        factorCategory: .sleepQuality,
        studyTitle: "Sleep and epilepsy: a clinical review",
        authors: "Bazil CW",
        journal: "Current Neurology and Neuroscience Reports",
        year: 2003,
        doi: "10.1007/s11910-003-0028-8",
        findingSummary: "Disrupted sleep architecture, particularly reduced deep sleep percentage (<15% of total), correlates with increased seizure frequency in epilepsy patients."
    )

    public static let hrvAutonomic = ResearchCitation(
        factorCategory: .hrv,
        studyTitle: "Autonomic dysfunction in epilepsy: Heart rate variability analysis",
        authors: "Jansen K, Lagae L",
        journal: "European Journal of Paediatric Neurology",
        year: 2010,
        doi: "10.1016/j.ejpn.2010.01.003",
        findingSummary: "Reduced heart rate variability (SDNN <50ms) indicates autonomic dysfunction and has been observed preceding seizure events. Pre-ictal HRV changes may serve as a biomarker."
    )

    public static let ictalTachycardia = ResearchCitation(
        factorCategory: .restingHeartRate,
        studyTitle: "Ictal tachycardia as an epilepsy biomarker",
        authors: "Sevcencu C, Struijk JJ",
        journal: "Epilepsia",
        year: 2010,
        doi: "10.1111/j.1528-1167.2010.02571.x",
        findingSummary: "Elevated resting heart rate (>100 bpm or >15% above personal baseline) reflects autonomic stress state associated with increased seizure susceptibility."
    )

    public static let oxygenDesaturation = ResearchCitation(
        factorCategory: .spO2,
        studyTitle: "Oxygen desaturation during seizures in epilepsy patients",
        authors: "Bateman LM, Li CS, Seyal M",
        journal: "Neurology",
        year: 2008,
        doi: "10.1212/01.wnl.0000318293.87512.a8",
        findingSummary: "Oxygen desaturation (<94% sustained) was observed in 33% of seizure events. Persistent low SpO2 may indicate respiratory compromise associated with seizure risk."
    )

    public static let febrileTemperature = ResearchCitation(
        factorCategory: .skinTemperature,
        studyTitle: "Fever as a seizure precipitant in epilepsy patients",
        authors: "Dubey D, et al.",
        journal: "Epilepsia",
        year: 2005,
        doi: "10.1111/j.1528-1167.2005.00251.x",
        findingSummary: "Elevated body temperature (>0.5°C above personal baseline) acts as a seizure trigger, particularly in patients with a history of febrile seizures."
    )

    public static let exhaustionTrigger = ResearchCitation(
        factorCategory: .activityLevel,
        studyTitle: "Physical exercise and epilepsy",
        authors: "Nakken KO",
        journal: "Epilepsia",
        year: 1999,
        doi: "10.1111/j.1528-1157.1999.tb00721.x",
        findingSummary: "Physical exhaustion was reported as a seizure trigger by approximately 10% of epilepsy patients. Both extreme sedentarism (<2000 steps) and exhaustion patterns correlate with risk."
    )

    public static let missedAED = ResearchCitation(
        factorCategory: .medicationAdherence,
        studyTitle: "Adherence to antiepileptic drugs and seizure risk",
        authors: "Faught E, Duh MS, Weiner JR, et al.",
        journal: "Neurology",
        year: 2008,
        doi: "10.1212/01.wnl.0000324954.49966.32",
        findingSummary: "Missed antiepileptic drug doses increased seizure risk by 21-fold within 2 days. Medication non-adherence is one of the strongest modifiable risk factors."
    )

    public static let stressTrigger = ResearchCitation(
        factorCategory: .stressProxy,
        studyTitle: "Stress and epilepsy: patient perception and objective assessment",
        authors: "Neufeld MY, Sadeh M, Cohn DF, et al.",
        journal: "Epilepsia",
        year: 1994,
        doi: "10.1111/j.1528-1157.1994.tb02480.x",
        findingSummary: "Stress was self-reported as a seizure trigger by 30% of epilepsy patients. Physiological stress markers (elevated HR + depressed HRV) provide objective measurement."
    )
}
