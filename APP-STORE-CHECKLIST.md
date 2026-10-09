# App Store Checklist — My CareLayer

Status key: ✅ done in this build · ☐ TODO (Chanelle decision/action) ·
◐ partially done.

## Code & project

- ✅ Opens in Xcode 15/16, compiles as a native SwiftUI app (no WebView)
- ✅ iOS 17.0 deployment target, Swift 5, single app target + tests
- ✅ No third-party dependencies, no network code, no analytics/ads
- ✅ No real person's data hardcoded; sample data is fictional and opt-in
- ✅ Offline: all core functions work in Airplane Mode
- ✅ Unit tests port the web self-tests (audiences, parsing, formatting)
- ☐ Run the full test suite on a Mac and fix any failures before submission
- ☐ Test on a physical device, not only the simulator

## Chanelle must decide / provide

- ☐ **Bundle identifier** — `com.chanellehenry.carelayer` is a
  placeholder; confirm ownership or replace
- ☐ **Apple Developer Program** enrollment (needed for App Store)
- ☐ **App icon** — PNG set incl. 1024×1024 (asset catalog has slots only)
- ☐ **Privacy policy URL** — required by App Store Connect even though
  the app collects no data; PRIVACY-NOTES.md can seed the page
- ☐ **Support URL** and contact email for the listing
- ☐ **App name / subtitle / description / keywords** for the listing
- ☐ **Screenshots** (required device sizes) — capture from the running app
- ☐ **Age rating questionnaire** — expect 12+ or 17+ answers around
  medical information; answer honestly in App Store Connect
- ☐ **Category** — Medical or Health & Fitness (primary) decision

## Medical / content safety

- ◐ The card footer disclaimer ships in-app and in every share:
  "Patient-provided context. Use clinical judgment and verify details
  as needed."
- ☐ Confirm the app makes **no diagnostic or treatment claims** in
  listing copy — it presents user-provided context only
- ☐ Review audience copy once more with fresh eyes before submission
  (it is the web prototype's copy, verbatim — including its clinical
  phrasing)
- ☐ Consider whether an in-app disclaimer belongs on the audience
  screens as well as the card (currently card + shares only)

## Privacy & compliance

- ✅ App Privacy answers prepared: **Data Not Collected** (see
  PRIVACY-NOTES.md)
- ✅ No permissions requested — no usage-description strings needed
- ✅ Export compliance: the app uses no non-exempt encryption (no
  network, no custom crypto) — answer "No" to encryption use in
  App Store Connect, or add `ITSAppUsesNonExemptEncryption = NO`
- ☐ Privacy policy URL live and matching PRIVACY-NOTES.md
- ☐ Review notes for App Review: explain local-only storage, how to
  load the sample profile for review, and that no account exists

## Accessibility (verify before submission)

- ◐ Dynamic Type: text styles only — verify largest accessibility
  sizes don't clip on Home, Audience, Card, Profile
- ◐ VoiceOver pass on: onboarding, audience grid, accordions, card,
  QR sheet, profile editor
- ◐ Reduce Motion pass: accordion + onboarding paging
- ☐ Verify contrast in Dark Mode (palette is a fixed light palette —
  decide whether Dark Mode needs its own pass or a light-only lock)
- ☐ Accessibility Nutrition Labels (App Store Connect, optional but
  recommended): VoiceOver, Dynamic Type, Sufficient Contrast, Reduced Motion

## Release mechanics

- ☐ Archive build (Release) succeeds with signing
- ☐ TestFlight build to at least one external tester
- ☐ Version/build numbers set (currently 1.0 / 1)
- ☐ "What's New" release notes drafted
