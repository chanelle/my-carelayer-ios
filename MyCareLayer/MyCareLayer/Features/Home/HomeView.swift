import SwiftUI

struct HomeView: View {
    let profile: UserProfile
    @State private var showingCard = false
    @State private var showingProfileEditor = false

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                heroCard
                audienceSection
            }
            .padding(CareSpacing.medium)
        }
        .background(CarePalette.background)
        .navigationTitle("CareLayer")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { showingCard = true } label: {
                    Image(systemName: "circle.circle.fill")
                }
                .accessibilityLabel("Preview Medical Alert Card")
            }
        }
        .navigationDestination(for: Audience.self) { audience in
            AudienceView(audience: audience, profile: profile)
        }
        .navigationDestination(isPresented: $showingCard) {
            EmergencyCardView(profile: profile)
        }
        .sheet(isPresented: $showingProfileEditor) {
            NavigationStack { ProfileEditorView(profile: profile) }
        }
    }

    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 12) {
                Text("PRIMARY CARD")
                    .font(.caption2.weight(.semibold)).tracking(2)
                    .foregroundStyle(.white.opacity(0.75))
                    .padding(.horizontal, 10).padding(.vertical, 4)
                    .background(Color.white.opacity(0.14)).clipShape(Capsule())
                Text("Medical Alert")
                    .font(.largeTitle.weight(.semibold))
                    .accessibilityAddTraits(.isHeader)
                Text("Your electronic medical bracelet for EDS and related conditions.")
                    .font(.body).foregroundStyle(.white.opacity(0.85))
                if !profile.relatedConditions.isEmpty {
                    HStack(spacing: 8) {
                        ForEach(profile.relatedConditions.prefix(3), id: \.self) {
                            ConditionChip(text: $0, onDark: true)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .background(CarePalette.primary)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))

            VStack(spacing: 10) {
                Button { showingCard = true } label: {
                    Text("Show My Alert Card")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: CareSpacing.minTouchTarget)
                }
                .buttonStyle(.borderedProminent).tint(CarePalette.primary)

                Button { showingProfileEditor = true } label: {
                    Text("Edit Profile")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: CareSpacing.minTouchTarget)
                }
                .buttonStyle(.bordered).tint(CarePalette.primary)
            }
            .padding(.horizontal, 4)
        }
        .padding(12)
        .careCard()
    }

    private var audienceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("AUDIENCE MODE")
                .font(.caption2.weight(.semibold)).tracking(2)
                .foregroundStyle(CarePalette.mutedText)
            Text("Who are you talking to?")
                .font(.title.weight(.semibold))
                .accessibilityAddTraits(.isHeader)
            Text("Choose the right view for the person you’re speaking with.")
                .font(.subheadline).foregroundStyle(CarePalette.mutedText)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(AudienceCatalog.all) { audience in
                    NavigationLink(value: audience) {
                        AudienceTile(audience: audience)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
