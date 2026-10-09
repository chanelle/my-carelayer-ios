import SwiftUI

/// Fixed-width snapshot of the emergency card for ImageRenderer sharing.
/// The on-screen card stays the live, Dynamic Type-safe EmergencyCardView;
/// this snapshot is a rendering target only (360pt design width).
struct EmergencyCardSnapshot: View {
    let profile: UserProfile

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("CARELAYER")
                    .font(.title3.weight(.medium))
                    .tracking(3)
                Text("MEDICAL ALERT CARD")
                    .font(.caption.weight(.semibold))
                    .tracking(3)
                    .foregroundStyle(CarePalette.gold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .background(CarePalette.primary)
            .foregroundStyle(.white)

            VStack(alignment: .leading, spacing: 14) {
                snapshotRow("Name", profile.displayName.isEmpty ? "Not set" : profile.displayName)
                if !profile.primaryConditionType.isEmpty {
                    snapshotRow("Conditions", Formatting.joinList(
                        [profile.primaryConditionType] + profile.relatedConditions))
                }
                snapshotRow("Medications", profile.medications.isEmpty
                    ? "No medications added." : Formatting.joinList(profile.medications))
                snapshotRow("Allergies & Sensitivities", profile.allergies.isEmpty
                    ? "No allergies added." : Formatting.joinList(profile.allergies))
                if profile.hasAdhesiveSensitivity {
                    Label("Adhesive sensitivity noted.", systemImage: "exclamationmark.triangle.fill")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(CarePalette.warning)
                }
                if !profile.criticalNotes.isEmpty {
                    snapshotRow("Critical Notes", profile.criticalNotes)
                }
                if !profile.emergencyContactName.isEmpty {
                    snapshotRow("Emergency Contact",
                                "\(profile.emergencyContactName) \(profile.emergencyContactPhone)")
                }
            }
            .padding(20)

            Text(ShareComposer.disclaimer)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.8))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(CarePalette.primary)
        }
        .frame(width: 360)
        .background(CarePalette.card)
    }

    private func snapshotRow(_ title: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.headline)
            Text(value).font(.subheadline).foregroundStyle(CarePalette.bodyTextSoft)
        }
    }
}

@MainActor
enum VisualCardRenderer {
    static func renderImage(profile: UserProfile) -> Image? {
        let renderer = ImageRenderer(content: EmergencyCardSnapshot(profile: profile))
        renderer.scale = 3
        guard let uiImage = renderer.uiImage else { return nil }
        return Image(uiImage: uiImage)
    }
}
