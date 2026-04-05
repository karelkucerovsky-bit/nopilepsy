# Contributing to Nopilepsy

Thank you for considering contributing to Nopilepsy. This project aims to help people with epilepsy passively monitor their seizure risk factors.

## Getting Started

1. Fork the repository
2. Clone your fork
3. Open `Nopilepsy.xcworkspace` in Xcode 15+
4. Build and run on iOS 17+ simulator or device

## Architecture

- **NopiCore** — Shared Swift Package (models, risk engine, HealthKit, baseline, export)
- **Nopilepsy** — iPhone app target (SwiftUI)
- **NopiWatch** — watchOS app target (SwiftUI)

## Guidelines

- All risk factor weights must cite published research (add to `CITATIONS.md`)
- Health data stays on-device by default
- No medical advice or recommendations in the UI
- Write unit tests for risk engine and data processing changes
- Use Swift Testing framework (`@Test`, `#expect`)
- Follow existing MVVM + Service Layer patterns

## Reporting Issues

Please include:
- Device model and OS version
- Steps to reproduce
- Expected vs actual behavior
- Screenshots if applicable

## Code of Conduct

Be respectful and constructive. This is a health-related project used by people with a serious medical condition.
