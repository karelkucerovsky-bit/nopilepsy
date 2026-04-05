# Nopilepsy

Free, open-source epilepsy seizure risk monitor for Apple Watch and iPhone.

Nopilepsy passively collects health sensor data from your Apple Watch, calculates a research-backed seizure risk level, and displays a dashboard with risk level and contributing factor breakdown. Pure monitoring — no medical advice, no health coaching.

## Features

- **Risk Dashboard** — Real-time risk score (0-100) with categorical level (Low/Moderate/Elevated/High)
- **9 Research-Backed Factors** — Sleep, HRV, heart rate, SpO2, temperature, activity, medication adherence, stress
- **Personal Baseline** — Learns your individual patterns over 2-4 weeks using exponential moving averages
- **Hybrid Engine** — Blends population research thresholds with your personal baseline for more accurate risk assessment
- **Full Transparency** — Every factor shows its research citation (DOI link to published study)
- **History & Trends** — Daily, weekly, monthly trend charts with color-coded risk zones
- **PDF/CSV Export** — Generate reports for your neurologist
- **Medication Tracking** — Optional adherence tracking for anti-epileptic drugs
- **Seizure Log** — Record events to identify patterns
- **Watch Complications** — Glanceable risk level on your watch face
- **Privacy First** — All data processed and stored on-device. No cloud, no tracking, no accounts.

## Requirements

- iOS 17.0+ / watchOS 10.0+
- Apple Watch Series 6+ (for SpO2 and temperature sensors)
- Xcode 15+

## Project Structure

```
nopilepsy/
  NopiCore/          Shared Swift Package
    Models/          SwiftData entities
    ValueTypes/      In-memory structs
    RiskEngine/      Hybrid risk calculation
    HealthKit/       Sensor data abstraction
    Baseline/        Personal baseline (EMA)
    Research/        Citations & factor table
    Export/          PDF & CSV generation
    Medication/      Adherence scoring
  Nopilepsy/         iPhone app (SwiftUI)
  NopiWatch/         Watch app (SwiftUI)
```

## Risk Engine

The hybrid risk engine combines two layers:

1. **Research Thresholds** — Static rules from published epilepsy studies (works from day 1)
2. **Personal Baseline** — EMA-based deviation detection (calibrates over 14-28 days)

Nine factors are evaluated, each with a weight based on research evidence:

| Factor | Weight | Source |
|--------|--------|--------|
| Sleep Duration | 0.22 | Malow et al., Neurology 2004 |
| HRV | 0.20 | Jansen & Lagae, EJPN 2010 |
| Medication Adherence | 0.15 | Faught et al., Neurology 2008 |
| Sleep Quality | 0.10 | Bazil, CNNR 2003 |
| Resting Heart Rate | 0.10 | Sevcencu & Struijk, Epilepsia 2010 |
| Blood Oxygen (SpO2) | 0.08 | Bateman et al., Neurology 2008 |
| Skin Temperature | 0.05 | Dubey et al., Epilepsia 2005 |
| Activity Level | 0.05 | Nakken, Epilepsia 1999 |
| Stress Proxy | 0.05 | Neufeld et al., Epilepsia 1994 |

See [CITATIONS.md](CITATIONS.md) for full references with DOIs.

## Disclaimer

**Nopilepsy is not a medical device.** It is not FDA-approved and is not intended to diagnose, treat, cure, or prevent any disease. It does not detect seizures. Always follow your neurologist's medical advice. See the in-app disclaimer for full details.

## License

MIT License. See [LICENSE](LICENSE).
