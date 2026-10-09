# Xcode Setup — My CareLayer

## Requirements

- macOS with **Xcode 15 or 16** (SwiftData requires the iOS 17 SDK)
- iOS **17.0** deployment target
- An Apple ID for signing (a paid Developer Program account is only
  needed for App Store submission / TestFlight distribution)

There are **no dependencies**: no Swift Package Manager packages, no
CocoaPods, no network fetches at build time.

## Steps

1. Open `MyCareLayer/MyCareLayer.xcodeproj` in Xcode.
   The project file uses explicit file references (no synchronized
   groups), so it opens the same way on any machine.
2. Select the **MyCareLayer** target → **Signing & Capabilities**:
   - Check "Automatically manage signing".
   - Choose your Team.
   - Bundle identifier is preset to `com.chanellehenry.carelayer`.
     This is a **placeholder** — change it to an identifier you own
     before submitting (e.g. under your own domain). If you change the
     app's ID, also change the test target's
     `com.chanellehenry.carelayer.tests` to match the prefix.
3. Choose a run destination: any iOS 17+ simulator (e.g. iPhone 15) or
   a physical device signed into your Apple ID.
4. Press **Run** (⌘R). First launch shows onboarding.
   - "Start" creates an empty profile.
   - "Use sample profile to explore" loads the fictional demo profile.
5. Run tests with **Test** (⌘U) — target `MyCareLayerTests` ports the
   web app's built-in self-tests (six audiences, list parsing, DOB and
   phone formatting) plus share-text coverage.

## Info.plist

The project uses a generated Info.plist (`GENERATE_INFOPLIST_FILE = YES`)
with build-setting keys for display name ("My CareLayer"), scene
manifest generation, and a generated launch screen
(`INFOPLIST_KEY_UILaunchScreen_Generation = YES`) — there is no
storyboard and no separate Info.plist file to edit. Add future keys
(e.g. a HealthKit usage description, if that feature is ever built) as
`INFOPLIST_KEY_…` build settings or by adding a plist then.

## App icon

`Assets.xcassets/AppIcon.appiconset` contains only `Contents.json`
slot definitions — **no icon images are included**. Drop real PNGs
into the slots in Xcode's asset catalog before App Store submission
(a 1024×1024 marketing icon is required). The AccentColor asset is
set to the CareLayer deep green `#20483A`.

## Resetting app data during development

Delete the app from the simulator/device, or use Profile →
"Clear my information" in the app. The SwiftData store lives in the
app sandbox; there is no server copy to clean up.

## Troubleshooting

- **"No such module" / missing file errors** — confirm you opened the
  `.xcodeproj` inside the `MyCareLayer/` folder, not the docs folder.
- **Signing errors on a physical device** — set your Team (step 2) and
  trust the developer profile on the device under Settings → General →
  VPN & Device Management.
- **SwiftData store errors after model changes** — delete the app from
  the destination and run again (pre-release; no migration is set up).
