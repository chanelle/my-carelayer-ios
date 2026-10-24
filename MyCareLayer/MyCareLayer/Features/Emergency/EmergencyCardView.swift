import SwiftUI

/// The Medical Alert Card, in the web app's exact section order, plus
/// brief-only profile fields when the user has filled them in.
struct EmergencyCardView: View {
    let profile: UserProfile
    @State private var showingQR = false
    @State private var showingProfileEditor = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                card
                HStack(spacing: 12) {
                    Button { showingQR = true } label: {
                        Label("Show QR", systemImage: "qrcode")
                            .frame(maxWidth: .infinity, minHeight: CareSpacing.minTouchTarget)
                    }
                    .buttonStyle(.borderedProminent).tint(CarePalette.primary)

                    ShareLink(item: ShareComposer.emergencyCardText(profile: profile)) {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .frame(maxWidth: .infinity, minHeight: CareSpacing.minTouchTarget)
                    }
                    .buttonStyle(.bordered).tint(CarePalette.primary)
                }
                if let image = VisualCardRenderer.renderImage(profile: profile) {
                    ShareLink(item: image,
                              preview: SharePreview("Medical Alert Card", image: image)) {
                        Label("Share Card Image", systemImage: "photo")
                            .frame(maxWidth: .infinity, minHeight: CareSpacing.minTouchTarget)
                    }
                    .buttonStyle(.bordered).tint(CarePalette.primary)
                }
                Button { showingProfileEditor = true } label: {
                    Label("Edit Profile", systemImage: "pencil")
                        .frame(maxWidth: .infinity, minHeight: CareSpacing.minTouchTarget)
                }
                .buttonStyle(.bordered).tint(CarePalette.primary)
            }
            .padding(CareSpacing.medium)
        }
        .background(CarePalette.background)
        .navigationTitle("Medical Alert Card")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingQR) {
            NavigationStack { QRCodeView(payload: ShareComposer.emergencyCardText(profile: profile)) }
        }
        .sheet(isPresented: $showingProfileEditor) {
            NavigationStack { ProfileEditorView(profile: profile, isSheet: true) }
        }
    }

    private var card: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("CARELAYER")
                    .font(.title.weight(.medium)).tracking(4)
                Text("MEDICAL ALERT CARD")
                    .font(.caption.weight(.semibold)).tracking(4)
                    .foregroundStyle(CarePalette.gold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .background(CarePalette.primary)
            .foregroundStyle(.white)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("CareLayer Medical Alert Card")

            cardSection("Identity") {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(profile.displayName.isEmpty ? "Not set" : profile.displayName)
                            .font(.headline)
                        Text("DOB: \(Formatting.formatDOB(profile.dateOfBirth).isEmpty ? "Not set" : Formatting.formatDOB(profile.dateOfBirth))")
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        if !profile.ageLabel.isEmpty { Text(profile.ageLabel) }
                        if !profile.pronouns.isEmpty {
                            Text(profile.pronouns).fontWeight(.semibold)
                        }
                    }
                }
            }
            cardSection("Conditions") {
                VStack(alignment: .leading, spacing: 4) {
                    if !profile.primaryConditionType.isEmpty { Text(profile.primaryConditionType) }
                    if !profile.conditionStatus.isEmpty {
                        Text("Status: \(profile.conditionStatus)")
                            .foregroundStyle(CarePalette.accent).fontWeight(.medium)
                    }
                    if !profile.relatedConditions.isEmpty {
                        Text(Formatting.joinList(profile.relatedConditions))
                    }
                }
            }
            cardSection("Medications") {
                Text(profile.medications.isEmpty ? "No medications added." : Formatting.joinList(profile.medications))
            }
            cardSection("Allergies & Sensitivities") {
                VStack(alignment: .leading, spacing: 6) {
                    Text(profile.allergies.isEmpty ? "No allergies added." : Formatting.joinList(profile.allergies))
                    if profile.hasAdhesiveSensitivity {
                        // Text + symbol, never color alone.
                        Label("Adhesive sensitivity noted.", systemImage: "exclamationmark.triangle.fill")
                            .fontWeight(.semibold)
                            .foregroundStyle(CarePalette.warning)
                    }
                }
            }
            cardSection("Mobility / Positioning") {
                Text(profile.mobilityAids.isEmpty ? "No mobility aids added." : Formatting.joinList(profile.mobilityAids))
            }
            if !profile.criticalNotes.isEmpty {
                cardSection("Critical Notes") { Text(profile.criticalNotes) }
            }
            extendedSections
            if !profile.emergencyContactName.isEmpty || !profile.emergencyContactPhone.isEmpty {
                cardSection("Emergency Contact") {
                    HStack {
                        Text(profile.emergencyContactName).fontWeight(.semibold)
                        Spacer()
                        Text(profile.emergencyContactPhone)
                    }
                }
            }

            Text(ShareComposer.disclaimer)
                .font(.footnote)
                .foregroundStyle(.white.opacity(0.85))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(CarePalette.primary)
        }
        .background(CarePalette.card)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(CarePalette.gold.opacity(0.6), lineWidth: 1))
    }

    @ViewBuilder
    private var extendedSections: some View {
        if !profile.sensoryNeeds.isEmpty {
            cardSection("Sensory Needs") { Text(profile.sensoryNeeds) }
        }
        if !profile.communicationNeeds.isEmpty {
            cardSection("Communication Needs") { Text(profile.communicationNeeds) }
        }
        if !profile.accommodations.isEmpty {
            cardSection("Accommodations") { Text(profile.accommodations) }
        }
        if !profile.medicalHistoryNotes.isEmpty {
            cardSection("Important Medical History") { Text(profile.medicalHistoryNotes) }
        }
        if !profile.clinicianNotes.isEmpty {
            cardSection("Notes for Clinicians") { Text(profile.clinicianNotes) }
        }
    }

    private func cardSection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            content()
                .font(.body)
                .foregroundStyle(CarePalette.bodyTextSoft)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(CareSpacing.medium)
        .overlay(alignment: .bottom) { Divider().overlay(CarePalette.ring) }
    }
}
