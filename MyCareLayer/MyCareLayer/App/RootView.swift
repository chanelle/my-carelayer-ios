import SwiftUI
import SwiftData

/// Root: onboarding gate, single-profile bootstrap, then the three-tab
/// shell mirroring the web bottom nav (Home / Card / Profile).
struct RootView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @Query private var profiles: [UserProfile]
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab = 0

    var body: some View {
        Group {
            if !hasCompletedOnboarding {
                OnboardingView()
            } else if let profile = profiles.first {
                TabView(selection: $selectedTab) {
                    NavigationStack { HomeView(profile: profile) }
                        .tabItem { Label("Home", systemImage: "house.fill") }
                        .tag(0)
                    NavigationStack { EmergencyCardView(profile: profile) }
                        .tabItem { Label("Card", systemImage: "rectangle.stack.fill") }
                        .tag(1)
                    NavigationStack { ProfileEditorView(profile: profile) }
                        .tabItem { Label("Profile", systemImage: "person.circle.fill") }
                        .tag(2)
                }
                .tint(CarePalette.primary)
            } else {
                // Onboarding flag set but no profile (e.g. store reset):
                // recreate an empty profile rather than dead-ending.
                ProgressView("Setting up…")
                    .onAppear {
                        modelContext.insert(UserProfile())
                        try? modelContext.save()
                    }
            }
        }
        .background(CarePalette.background)
    }
}
