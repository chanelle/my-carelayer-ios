# My CareLayer — Native iOS

A native SwiftUI rebuild of the CareLayer web prototype: a **medical
context card** for EDS, chronic illness, and invisible disability.

When you are sick, in pain, or overwhelmed, you should not have to
re-explain your condition, needs, and risks to every new person.
CareLayer asks one question — **"Who are you talking to?"** — and shows
that person the right information: a Quick Summary, why it matters,
common mistakes, safety considerations, and what helps, plus the parts
of your profile that are relevant to them.

## Principles

- **Local-first** — your profile lives only on your device (SwiftData).
- **No account** — no login, no backend, no database server.
- **No AI dependency** — fully useful offline, with no network at all.
- **User-controlled disclosure** — nothing is shared unless you tap Share.
- **Accessibility as architecture** — Dynamic Type, VoiceOver, 44pt+
  targets, reduced-motion support, non-color-only indicators.

## What's in Version 1

- 3-page onboarding (what it does / stays on your device / you control
  sharing), with Start-empty or explore-with-sample choices
- Editable profile (identity, medical context, communication & sensory
  needs, notes, emergency contact) with chip multi-select editors
- "Who are you talking to?" home with 6 audience tiles: Nurse,
  Primary Care, Emergency Room, Orthopedic, Physical Therapy,
  Friend / Family
- Audience CareLayer screens with the original prototype's copy, verbatim
- Medical Alert (Emergency) Card with adhesive-sensitivity warning
- Native sharing: formatted text, visual card image, and a QR code —
  always initiated by you
- Full offline operation

The sample profile ("Alexandra Morgan") is fictional demo data from
the web prototype, loaded only when you choose it. No real person's
medical information is in this app.

## Getting started

See `XCODE-SETUP.md`. In short: open
`MyCareLayer/MyCareLayer.xcodeproj` in Xcode 15 or 16, pick your
signing team, run on a simulator or device (iOS 17+).

## Documents

- `MIGRATION-AUDIT.md` — what the web app did, and how it mapped here
- `IOS-ARCHITECTURE.md` — models, navigation, persistence, sharing, a11y
- `XCODE-SETUP.md` — build and run instructions
- `PRIVACY-NOTES.md` — what data exists, where it lives, what sharing sends
- `APP-STORE-CHECKLIST.md` — submission checklist with open decisions

## Not in Version 1 (architecture leaves seams — see IOS-ARCHITECTURE.md)

HealthKit, Apple Watch, Wallet pass, widgets, App Intents / Siri,
medication import, encrypted cloud backup, AI summarization.
