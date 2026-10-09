import SwiftUI

struct AudienceView: View {
    let audience: Audience
    let profile: UserProfile

    /// Chips in web order: status, shortened EDS type, related (max 5 total).
    private var chips: [String] {
        var values: [String] = []
        if !profile.conditionStatus.isEmpty { values.append(profile.conditionStatus) }
        if !profile.primaryConditionType.isEmpty {
            values.append(Formatting.shortenedCondition(profile.primaryConditionType))
        }
        values.append(contentsOf: profile.relatedConditions)
        return Array(values.prefix(5))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                headerCard
                profileHighlights
                ForEach(Array(audience.sections.enumerated()), id: \.element.id) { index, section in
                    SectionCard(title: section.title, items: section.items, defaultOpen: index == 0)
                }
                ShareLink(item: ShareComposer.audienceText(audience: audience, profile: profile)) {
                    Label("Share This CareLayer", systemImage: "square.and.arrow.up")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: CareSpacing.minTouchTarget)
                }
                .buttonStyle(.borderedProminent).tint(CarePalette.primary)
            }
            .padding(CareSpacing.medium)
        }
        .background(CarePalette.background)
        .navigationTitle(audience.label)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 16) {
                ZStack {
                    Circle().fill(CarePalette.chipBackground).frame(width: 56, height: 56)
                    VStack(spacing: 0) {
                        Text(audience.glyph).font(.title3).foregroundStyle(CarePalette.primary)
                        Image(systemName: audience.sfSymbol).font(.caption2).foregroundStyle(CarePalette.primary)
                    }
                }
                .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 6) {
                    Text("Show this to:")
                        .font(.subheadline).foregroundStyle(CarePalette.mutedText)
                    Text(audience.label)
                        .font(.largeTitle.weight(.semibold))
                        .accessibilityAddTraits(.isHeader)
                }
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("Quick Summary")
                    .font(.headline).accessibilityAddTraits(.isHeader)
                Text(audience.summary)
                    .font(.body).foregroundStyle(CarePalette.bodyTextSoft)
            }
            if !chips.isEmpty {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), alignment: .leading)],
                          alignment: .leading, spacing: 8) {
                    ForEach(chips, id: \.self) { ConditionChip(text: $0) }
                }
            }
        }
        .padding(20)
        .careCard()
    }

    @ViewBuilder
    private var profileHighlights: some View {
        let hasHighlights = !profile.medications.isEmpty || !profile.allergies.isEmpty
            || !profile.mobilityAids.isEmpty || profile.hasAdhesiveSensitivity
            || !profile.sensoryNeeds.isEmpty || !profile.communicationNeeds.isEmpty
            || !profile.accommodations.isEmpty
        if hasHighlights {
            VStack(alignment: .leading, spacing: 10) {
                Text("From your profile")
                    .font(.headline).accessibilityAddTraits(.isHeader)
                if !profile.medications.isEmpty {
                    highlightRow("Medications", Formatting.joinList(profile.medications))
                }
                if !profile.allergies.isEmpty {
                    highlightRow("Allergies", Formatting.joinList(profile.allergies))
                }
                if profile.hasAdhesiveSensitivity {
                    Label("Adhesive sensitivity noted.", systemImage: "exclamationmark.triangle.fill")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(CarePalette.warning)
                }
                if !profile.mobilityAids.isEmpty {
                    highlightRow("Mobility / positioning", Formatting.joinList(profile.mobilityAids))
                }
                if !profile.communicationNeeds.isEmpty {
                    highlightRow("Communication needs", profile.communicationNeeds)
                }
                if !profile.sensoryNeeds.isEmpty {
                    highlightRow("Sensory needs", profile.sensoryNeeds)
                }
                if !profile.accommodations.isEmpty {
                    highlightRow("Accommodations", profile.accommodations)
                }
            }
            .padding(CareSpacing.medium)
            .careCard()
        }
    }

    private func highlightRow(_ title: String, _ value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title).font(.subheadline.weight(.semibold)).foregroundStyle(CarePalette.mutedText)
            Text(value).font(.body).foregroundStyle(CarePalette.bodyTextSoft)
        }
    }
}
