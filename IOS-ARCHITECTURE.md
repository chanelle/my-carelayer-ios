# iOS Architecture — My CareLayer

## Stack

Swift 5 · SwiftUI · SwiftData · iOS 17.0 deployment target · Xcode 15/16.
No third-party dependencies, no SPM packages, no network code anywhere.

Pattern: **MV with SwiftData** — views read/write `@Model` objects
directly via `@Query` / `@Bindable`; stateless helper enums own
formatting, share-text composition, and static content. No view models
were added where SwiftUI + SwiftData already provide the binding.

## Layout

```
MyCareLayer/
  App/          MyCareLayerApp (@main, ModelContainer), RootView (tabs + onboarding gate)
  Models/       UserProfile (@Model), Audience / AudienceSection (value types)
  Content/      AudienceCatalog (6 audiences verbatim), ProfileOptions (lists + sample contacts)
  Support/      Formatting (splitList, DOB, phone, chip shortening)
  Design/       Theme (CarePalette hex tokens, CareSpacing, careCard modifier)
  Components/   ConditionChip, SectionCard (accordion), AudienceTile, ChipMultiSelectEditor
  Features/     Onboarding / Home / Audience / Emergency / Profile
  Sharing/      ShareComposer (text), QRCodeView (CoreImage), VisualCardShare (ImageRenderer)
MyCareLayerTests/  XCTest port of the web self-tests + formatting/share coverage
```

## Data model

`UserProfile` (SwiftData `@Model`, single instance per install):

| Field | Type | Notes |
|---|---|---|
| displayName | String | |
| ageLabel | String | Verbatim web options ("27 yrs", "Prefer not to say"). **Manual, never derived from DOB** — faithful to the source, where the two diverge (demo: "27 yrs" vs. DOB Apr 05, 1997). See MIGRATION-AUDIT Quirks (a) |
| dateOfBirth | Date? | Displayed "Apr 05, 1997". Independent of `ageLabel` by design |
| pronouns | String | Picker list or custom |
| primaryConditionType | String | EDS type list or custom |
| conditionStatus | String | Status list |
| relatedConditions, medications, allergies, mobilityAids | [String] | SwiftData-native arrays (web used comma strings; `Formatting.splitList` preserves the parsing behavior for tests/import) |
| hasAdhesiveSensitivity | Bool | Drives the card warning |
| sensoryNeeds, communicationNeeds, accommodations, medicalHistoryNotes, clinicianNotes | String | Native-brief fields; rendered/shared only when non-empty |
| criticalNotes | String | |
| emergencyContactName, emergencyContactPhone | String | Phone formatted by `Formatting.formatPhone` |

`Audience` is a plain struct (Identifiable, Hashable) so it can drive
`NavigationLink(value:)`; content is compile-time data in
`AudienceCatalog`, never persisted.

## Navigation model

- `RootView` gates on `@AppStorage("hasCompletedOnboarding")`.
- Main shell: `TabView` — Home / Card / Profile — mirroring the web
  bottom nav. Each tab owns a `NavigationStack`.
- Home pushes `AudienceView` via `Audience` values; the hero card and
  toolbar button push `EmergencyCardView`; Edit Profile is a sheet so
  it is reachable from Home, Card, and Audience contexts without
  disturbing the tab the user is in.

## Persistence strategy

- One SwiftData `ModelContainer` for `UserProfile`, created in
  `MyCareLayerApp` via `.modelContainer(for:)`. Default on-device
  store in the app sandbox — no CloudKit, no sync, no backend.
- `@AppStorage` is used for exactly one non-sensitive flag:
  `hasCompletedOnboarding`.
- Editor saving: edits bind directly to the `@Model`; the explicit
  Save button calls `modelContext.save()` and shows "Saved" for 2s,
  preserving the web affordance (documented in `ProfileEditorView`).
- "Clear my information" zeroes the single profile behind a
  confirmation dialog. "Load sample profile" overwrites with demo data
  by explicit action only.

## Sharing strategy

All sharing is user-initiated `ShareLink`; nothing is ever sent
programmatically.

- **Text** — `ShareComposer` builds audience text (title, Quick
  Summary, profile chips line, 4 sections, extended fields if filled,
  disclaimer) and emergency-card text (same section order as the card).
  Only non-empty user fields are included.
- **Visual card** — `VisualCardShare`: a fixed 360pt-wide
  `EmergencyCardSnapshot` rendered with `ImageRenderer` (scale 3) and
  shared as an image. The live on-screen card remains the accessible,
  Dynamic Type-safe view; the snapshot is a render target only.
- **QR** — `QRCodeView` uses `CIFilter.qrCodeGenerator` on the exact
  emergency-card text payload. The screen warns, in plain language,
  that anyone who scans it can read it, and offers the QR image itself
  via `ShareLink`.

## Accessibility approach

| Requirement | Implementation |
|---|---|
| Dynamic Type | Only system text styles (`.body`, `.headline`, `.title`, …); no fixed font sizes for text anywhere |
| VoiceOver | Headings carry `.isHeader`; glyph+symbol tiles are combined into one labeled element; **every** icon-only control has an `accessibilityLabel` (fixing the web Home hero button, which had none); accordion state is announced ("expanded/collapsed"); content is rendered **once** — the web DOM duplicated audience text, a screen-reader duplication risk the native single-source catalog eliminates |
| Touch targets | Minimum 44pt (`CareSpacing.minTouchTarget`) on buttons, chips-remove, tiles, save |
| Contrast | Source palette pairs deep green on cream/white and white on deep green; warning uses text + `exclamationmark.triangle.fill` symbol |
| Non-color-only state | Show/Hide text pill + chevron on accordions; adhesive warning is a labeled `Label`, not just red text; selected tab is the system tab treatment |
| Reduced motion | `@Environment(\.accessibilityReduceMotion)` disables accordion/onboarding animations |
| Focus order | Source-order layout, one idea per onboarding page, no hidden gestures anywhere |
| Low cognitive load | One primary action per screen region; large audience tiles; emergency info reachable in ≤2 taps from launch (Card tab or Home hero) |

## Design tokens

`CarePalette`: primary `#20483A`, primaryDark `#17362D`, background
`#F6F1E7`, card `#FFFDF8`, ring `#E5DCCE`, mutedText `#6F7C75`,
bodyText `#18231F`, bodyTextSoft `#26332E`, accent `#4F9274`,
chipBackground `#DCEBDF`, gold `#E7C873`, warning `#B85C5C`.
AccentColor asset = deep green. Corner radius 20, spacing 8/16/24.

## Future integration points (seams, not code)

- **Possible future audience: Dentist** — a first-load-only variant of
  the web app showed a 7th "Dentist" tile (subtitle about TMJ / jaw /
  anesthesia), but its detail content was never retrievable and the
  variant vanished on reload (see MIGRATION-AUDIT.md, "Two builds
  exist"). It is **not** in the v1 catalog. Because audiences are pure
  data in `AudienceCatalog`, adding it later is one data entry — *if
  and when* source copy for its summary and four sections is supplied.
  No placeholder or invented copy ships in v1.

- **HealthKit** — a future `HealthImport` service would map readings
  into `UserProfile` fields; the model has no web-era string formats
  blocking structured data.
- **Apple Watch / Widgets / App Intents** — audience and card content
  are value types (`Audience`, composer output is a pure function of
  profile + audience), so a widget or intent can render/share without
  touching feature views.
- **Wallet emergency card** — `EmergencyCardSnapshot` is the visual
  source a future PassKit pass would mirror; `ShareComposer` text is
  the payload source.
- **Encrypted cloud backup** — persistence is isolated behind the
  single `ModelContainer`; swapping the store configuration does not
  touch views.
- **AI summarization** — explicitly out of scope; if ever added, it
  would consume `ShareComposer` output locally and remain optional.
