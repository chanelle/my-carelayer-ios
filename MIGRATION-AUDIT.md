# Migration Audit — My CareLayer (Web → Native iOS)

Source of truth audited: the live deployed web app at
`https://becomingbeta.com/my-carelayer-app/`, "CareLayer lean v3" —
a React PWA whose extracted logic is preserved in
`reference-live/carelayer-webapp-extracted-source.txt` in this folder.

**Authoritative-copy rule (reconciliation note):** where a browser
click-through paraphrase of any bullet or label differed from the
extracted bundle text, the bundle in `reference-live/` is authoritative.
All catalog copy in the native app is transcribed verbatim from the
bundle, never from a rendered-page paraphrase.

## Two builds exist — variant seen once (ambiguous / stale artifact)

A live click-through inventory found **two different builds**:

- **Stable build (the source of truth for this migration):** the
  6-audience "CareLayer lean v3" documented in the rest of this audit.
  It appeared on every reload.
- **First-load-only variant (ambiguous):** on first load only, a
  different variant appeared and then vanished on all reloads. It had:
  a hero titled **"My Medical Context"**, a tagline about shareable
  care profiles, buttons for an emergency card **and a personal QR**,
  and a **7th audience tile: Dentist** (subtitle about TMJ / jaw /
  anesthesia).

  The variant's Dentist detail content was **never retrievable** — no
  summary or section copy for Dentist exists in any available source.
  **Resolution:** the variant is documented here as an
  ambiguous/stale artifact (possibly a cached or superseded build).
  It is **not** migrated. No Dentist audience was added to the Swift
  catalog — inventing its clinical copy would violate the
  verbatim-copy rule. Dentist is noted only as a *possible future
  audience* in `IOS-ARCHITECTURE.md` (future integration points),
  pending retrievable source copy.

## What the web app does

A single-user, local-only "medical context card" for EDS, chronic illness,
and invisible disability (PWA manifest description, verbatim). The user
keeps one profile on the device, then shows audience-specific views of
that profile plus fixed educational content to whoever they are talking
to. Tagline: **"medical context card."**

## Screens and interactions

| Screen | Content / behavior |
|---|---|
| **Home** | Dark-green header (app name + "medical context card", ◉ button → Card). Hero card in a cream card: pill "primary card", title "Medical Alert", copy "Your electronic medical bracelet for EDS and related conditions.", first 3 related-condition chips. Buttons "Show My Alert Card" and "Edit Profile". Below: eyebrow "AUDIENCE MODE", heading "Who are you talking to?", subcopy "Choose the right view for the person you're speaking with.", 2-column audience tile grid (glyph in mint tile, label, short description). |
| **Audience view** | Back pill. Header card: glyph in mint circle, "Show this to:" + audience label (large), summary text, chips = status + EDS type (with the long hEDS string shortened to "hEDS") + related conditions, capped at 5. Below: accordion sections in source order — Why this matters / Common mistakes / Safety considerations / What helps — first open by default, Show/Hide text pill, 3 bullets each with green dot markers. |
| **Card view (Medical Alert Card)** | Back pill. Card with dark-green header: "CARELAYER" (letterspaced) / "MEDICAL ALERT CARD" in gold (#E7C873). Sections in order: Identity (name, "DOB: …", age, pronouns), Conditions (EDS type, "Status: …" in accent green, related conditions joined " • "), Medications, Allergies & Sensitivities (+ red "Adhesive sensitivity noted." when the flag is on), Mobility / Positioning, Critical Notes, Emergency Contact (name + phone). Footer (dark green): "Patient-provided context. Use clinical judgment and verify details as needed." Buttons: "Show QR" and "Edit Profile". |
| **Profile editor** | Header card: eyebrow "guided setup", title "My Profile", copy "Structured fields make the card easier to scan and safer to show." Sections: Identity (display name, age picker, DOB date picker with "Shows as:" preview, pronouns picker with Custom), Medical context (EDS type picker with Other/custom, status picker, chip multi-select for related conditions / medications / allergies / mobility aids with search + add-custom + tap-to-remove, critical notes textarea, adhesive sensitivity toggle with helper "Shows a warning on the card."), Emergency contact (picker from sample contacts, name, phone auto-formatted). Sticky Save button → persists and shows "Saved" for 2 seconds. |
| **Bottom nav** | Fixed dark-green pill nav, 3 items: Home ⌂ / Card ▣ / Profile ○. Audience views count as Home-active. |

## Content structure

- **Profile**: flat object — `displayName, age, dob, pronouns, edsType,
  edsStatus, relatedConditions, medications, allergies,
  adhesiveSensitivity, mobilityAids, emergencyContactName,
  emergencyContactPhone, criticalNotes`. List fields are stored as
  comma-joined strings and parsed with a `splitList` helper.
- **Audiences**: static array of 6 (`nurse, pcp, er, ortho, pt, family`).
  Each has `id, label, icon (glyph), short, summary, sections` — an
  ordered map of 4 section titles × 3 bullets. All copy is transcribed
  verbatim into `Content/AudienceCatalog.swift`.
- **Option lists**: pronouns (8), EDS types (6), statuses (6), related
  conditions (14), medications (10), allergies (9), mobility aids (10),
  age ("Prefer not to say" + "1 yrs"…"110 yrs") — all transcribed
  verbatim into `ProfileOptions`.
- **Demo/default profile**: Alexandra Morgan (see IOS source
  `UserProfile.makeSample()`). Fictional sample data (555 phone number).

## Confirmed live behavior (click-through inventory)

Independently confirmed against the live site, corroborating the
extracted source:

- **"Show QR" is a total no-op:** clicked 3× — no handler effect, and
  **no QR element exists in the DOM** at all. (See gap #1 below.)
- **No sharing of any kind:** no share, copy, export, or print
  affordance exists anywhere in the web app.
- **Save profile** flips its label to **"Saved" in place** — no dialog,
  no navigation. (The native editor mirrors this: explicit Save →
  "Saved" indicator for 2s, documented in `ProfileEditorView`.)
- **Emergency contact phone is NOT a `tel:` link** — it renders as
  plain text; tapping it does nothing. (Native card likewise presents
  it as text in v1; no tap-to-call was added, keeping behavior faithful
  and disclosure user-controlled.)
- **Persistence is local-only** (`localStorage`), nothing is sent
  anywhere — matching the native local-first design.

## Audience-view detail — status pill

The live audience view shows a **distinct status pill** alongside the
condition chips — e.g. "Diagnosed" for clinical audiences, and
"Gentle explanation" for Friend / Family. The native design's chips
approach (status + shortened condition type + related conditions, max 5)
covers the status-pill role; no separate pill component was built.
Noted here so the difference is a recorded decision, not an oversight:
if the per-audience pill wording (such as "Gentle explanation") is
later supplied from source, it can be added as data on `Audience`
without a screen redesign.

## Quirks documented from the live / source inventory

(a) **Age and DOB are independent, and can diverge.** Age is a manual
dropdown, never derived from DOB. The demo itself proves it: age shows
**"27 yrs"** with DOB **Apr 05, 1997** — which would be 29 in
October 2026. **Native resolution (faithful, deliberate):** the iOS
model keeps **both** fields exactly as the source does — `ageLabel`
(manual picker, verbatim options) and `dateOfBirth` — and does **not**
auto-derive age from DOB. Auto-deriving would silently change data the
user chose to present; the divergence risk is documented here instead.

(b) **Case-variant duplicate risk in chip lists.** The mobility
suggestion **"Cane during flares"** (options list) duplicates the
existing sample chip **"cane during flares"** (lowercase, from the
default profile's comma string) under case-sensitive comparison — the
web chip editor would happily hold both. **Native fix:**
`ChipMultiSelectEditor` dedupes **case-insensitively** — suggestions
already selected under a different casing are hidden, and `add(_:)`
rejects a case-insensitive duplicate. First-entered casing is kept, so
the sample profile's verbatim lowercase chip is preserved.

(c) **Duplicated audience text in the web DOM.** The web app renders
audience text **twice** in the DOM (likely a hidden duplicate layer),
which is a screen-reader duplication risk — assistive technology may
announce content twice. **Native resolution:** each audience string
has a single source (`AudienceCatalog`) and is rendered once per
screen; there is no hidden duplicate layer.

(d) **Unlabeled icon button on web Home.** The hero ◉ button on the
web Home screen has **no accessibility label** (the header ◉ button
does have one: "Preview Medical Alert Card"). **Native resolution:**
every icon-only control is labeled — e.g. the Home toolbar button
carries `.accessibilityLabel("Preview Medical Alert Card")`;
decorative glyph/SF Symbol images inside otherwise-labeled controls
are hidden from accessibility or combined into the control's label
(`AudienceTile`, chip remove buttons, accordion headers).

## Reusable concepts (kept natively)

Audience-first navigation ("Who are you talking to?"), the audience
CareLayer pattern (Quick Summary + 4 fixed sections), the Medical Alert
Card section order and disclaimer, chip-based list editing, the exact
color palette, the DOB display format ("Apr 05, 1997"), US phone
formatting, and the hEDS chip shortening.

## Web → native mapping

| Web | Native iOS |
|---|---|
| React state + view string (`home`, `card`, `profile`, `audience:<id>`) | `TabView` (Home / Card / Profile) + `NavigationStack` with `NavigationLink(value: Audience)` |
| `localStorage` key `carelayer-profile-v3-lean` | SwiftData `@Model UserProfile`, on-device store |
| Profile default-merge `pe = {...defaults, ...saved}` | **Not ported** — see gaps. Onboarding chooses empty profile or explicit sample load |
| Tailwind utility classes + inline `<style>` | `Design/Theme.swift` tokens (`CarePalette`, `CareSpacing`), Dynamic Type text styles |
| CSS animations (`pageDrop`, `tileDrop`, `presentCard`, drawer grid-rows) | System transitions only; all animation suppressed under Reduce Motion; accordion uses state + optional animation |
| `@media (prefers-reduced-motion: reduce)` | `@Environment(\.accessibilityReduceMotion)` |
| HTML `<select>`, `<input type="date">`, datalist chip editor | SwiftUI `Picker`, `DatePicker`, `ChipMultiSelectEditor` |
| PWA manifest (name, description, theme color) | App bundle display name "My CareLayer", AccentColor asset (deep green) |
| Built-in self-test function `T()` (console) | XCTest target `MyCareLayerTests` porting every assertion |

## Palette (verbatim hex)

Deep green `#20483A`, darker green `#17362D`, cream background
`#F6F1E7`, card `#FFFDF8`, ring/border `#E5DCCE`, muted text `#6F7C75`,
body text `#18231F` / `#26332E`, accent green `#4F9274`, chip background
`#DCEBDF`, gold `#E7C873`, warning red `#B85C5C`.

## Broken, missing, or ambiguous in the web version

1. **"Show QR" is a dead stub.** The button on the Card view has no
   handler at all — confirmed live: clicked 3×, total no-op, and no QR
   element exists in the DOM. Fixed natively: `Sharing/QRCodeView.swift`
   generates a real QR (CoreImage) whose payload is the emergency-card
   text, with a plain-language warning that anyone who scans it can read it.
2. **No sharing at all.** No share sheet, no export, no copy-out, no
   print — confirmed live. Fixed natively with `ShareLink` for audience
   text, card text, card image (ImageRenderer), and QR image.
3. **No onboarding.** The app drops the user straight onto Home with
   demo data already populated. Fixed natively: 3-page onboarding
   (what it does / stays on device / you control sharing) with an
   explicit choice — Start (empty) or Use sample profile to explore.
4. **Demo data is the default profile.** Saved data is merged *over*
   the demo defaults (`{...defaults, ...saved}`), so a user who never
   edited a field silently "has" Alexandra Morgan's values. This is a
   privacy/accuracy hazard in a medical context. **Not ported.** Native
   behavior: a real profile is empty until the user fills it; sample
   data loads only by explicit choice (onboarding or Profile → Manage).
5. **No "Learn More" section exists in this lean build**, although the
   product brief mentions it as an existing content pattern. It is not
   invented natively — flagged as a content gap for a future version.
6. **Mobility-aid casing inconsistency**: the default mobility string is
   "Knee brace, cane during flares, joint supports" (lowercase "cane")
   while the options list has "Cane during flares". Verbatim text is
   preserved as-is (sample profile keeps the string split; the option
   list keeps its casing), **but** the duplicate risk this creates is
   fixed natively — the Swift chip editor dedupes case-insensitively.
   See Quirks (b) above.
7. **Audience label mismatch**: the brief says "PCP" and "Orthopedic
   Specialist"; the source labels are "Primary Care" and "Orthopedic".
   Source wins (it is the shipped product copy); the brief's names are
   noted here.
8. **localStorage is unencrypted and origin-scoped** — any script on
   the origin could read the profile. Native store uses the app sandbox
   plus iOS Data Protection (see PRIVACY-NOTES.md).
9. **Audience sections object key order** is relied on for rendering
   order in JS. Natively modeled as an ordered `[AudienceSection]`
   array in the source's key order.

## Contradictions between brief and source — resolutions

| Conflict | Resolution |
|---|---|
| Brief fields (sensory needs, communication needs, accommodations, medical history, clinician notes) don't exist in the web profile | Added as native profile fields, empty by default, shown/shared **only when non-empty** (per task spec). No web copy invented for them. |
| Brief mentions "Learn More" as existing | Absent in lean v3 source. Not built; documented above. |
| Brief audience names vs. source labels | Source labels used verbatim. |
| Brief wants QR + sharing; web has neither working | Built natively as specified (QR payload = card text; sharing always user-initiated). |
| Source defaults to demo data | Overridden on privacy grounds (brief principle: user-controlled disclosure). Sample data is opt-in and clearly fictional. |
| First-load variant had a 7th audience (Dentist) and different hero | Ambiguous/stale artifact — vanished on reload, detail copy never retrievable. Not migrated; recorded above and as a possible future audience only. |
| Age could be auto-derived from DOB (they diverge in the demo) | Not derived. Both fields kept manual, faithful to source — see Quirks (a). |
| Browser click-through paraphrases vs. bundle text | Bundle in `reference-live/` is authoritative; catalog copy is verbatim from the bundle. |
