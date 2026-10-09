# Privacy Notes — My CareLayer

## The short version

My CareLayer collects nothing. There is no server, no account, no
analytics, no advertising, and no network code in the app at all.

## What data exists, and where

- The only stored data is the profile **you type in**, kept in a
  SwiftData store inside the app's sandbox on your device.
- One non-sensitive flag (`hasCompletedOnboarding`) is kept in
  `@AppStorage` so the app knows you have seen onboarding.
- The bundled sample profile ("Alexandra Morgan", 555 phone number) is
  fictional demo data from the public web prototype. It loads only if
  you explicitly choose "Use sample profile to explore" or
  Profile → Manage → "Load sample profile".

## Data protection

- The store inherits iOS Data Protection for files at rest (encrypted
  when the device is locked, on devices with a passcode).
- The app requests **no permissions**: no contacts, location, camera,
  photos, microphone, or notifications. The sample-contact picker in
  the profile editor uses the prototype's fictional sample contacts —
  it does not access your Contacts.
- No analytics SDKs, no ad/tracking SDKs, no third-party code at all.

## What sharing sends

Sharing is always initiated by you, through the iOS share sheet:

- **Audience share** — plain text: audience title, Quick Summary,
  relevant profile lines, the four sections, and the disclaimer.
- **Card share (text)** — the Medical Alert Card as plain text.
- **Card share (image)** — a rendered image of the card.
- **QR code** — contains exactly the same text as the card share.
  Anyone who scans it can read it; the QR screen says so before you
  share it.

Once you share something into another app (Messages, Mail, …), that
copy is governed by that app and the recipient — CareLayer cannot
recall it. Fields you leave empty are never included in shares.

## Deleting your data

Profile → Manage → "Clear my information" removes everything in the
profile. Deleting the app removes the store entirely. There is no
cloud copy to delete because there is no cloud.

## App Store privacy nutrition label (proposed answers)

- **Data Used to Track You:** None
- **Data Linked to You:** None
- **Data Not Linked to You:** None
- **Data Collection:** **Data Not Collected**

These answers are accurate for this codebase as shipped: it contains
no networking, analytics, or data-transmission code. If a future
version adds any network feature, this document and the label answers
must be revisited before release.
