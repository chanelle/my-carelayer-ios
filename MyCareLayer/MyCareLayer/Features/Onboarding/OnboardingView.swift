import SwiftUI
import SwiftData

/// Three short pages: what it does, stays on device, you control sharing.
/// Finish either creates an empty profile or loads the sample profile.
struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var page = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $page) {
                pageView(
                    symbol: "person.2.wave.2.fill",
                    title: "Show the right information to the right person",
                    bodyText: "Show the right information to the right person, in seconds. Pick who you are talking to — a nurse, your primary care provider, the emergency room, or a friend — and CareLayer shows what matters for them.")
                    .tag(0)
                pageView(
                    symbol: "iphone",
                    title: "Stays on your device",
                    bodyText: "Your information stays local by default. No account, no sign-in, and no cloud database. CareLayer works fully offline.")
                    .tag(1)
                pageView(
                    symbol: "hand.raised.fill",
                    title: "You control sharing",
                    bodyText: "Nothing leaves your phone unless you share it. You decide what is shown, what is shared, and who sees it — every time.")
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .animation(reduceMotion ? nil : .easeInOut, value: page)

            VStack(spacing: 12) {
                if page < 2 {
                    Button("Continue") { page += 1 }
                        .buttonStyle(.borderedProminent).tint(CarePalette.primary)
                        .frame(minHeight: CareSpacing.minTouchTarget)
                    Button("Skip") { page = 2 }
                        .frame(minHeight: CareSpacing.minTouchTarget)
                } else {
                    Button("Start") { finish(loadSample: false) }
                        .buttonStyle(.borderedProminent).tint(CarePalette.primary)
                        .frame(minHeight: CareSpacing.minTouchTarget)
                    Button("Use sample profile to explore") { finish(loadSample: true) }
                        .buttonStyle(.bordered).tint(CarePalette.primary)
                        .frame(minHeight: CareSpacing.minTouchTarget)
                }
            }
            .padding(CareSpacing.large)
        }
        .background(CarePalette.background)
    }

    private func pageView(symbol: String, title: String, bodyText: String) -> some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: symbol)
                .font(.system(size: 56))
                .foregroundStyle(CarePalette.primary)
                .accessibilityHidden(true)
            Text(title)
                .font(.title.weight(.semibold))
                .multilineTextAlignment(.center)
                .accessibilityAddTraits(.isHeader)
            Text(bodyText)
                .font(.body)
                .foregroundStyle(CarePalette.bodyTextSoft)
                .multilineTextAlignment(.center)
            Spacer()
            Spacer()
        }
        .padding(CareSpacing.large)
    }

    private func finish(loadSample: Bool) {
        let profile = loadSample ? UserProfile.makeSample() : UserProfile()
        modelContext.insert(profile)
        try? modelContext.save()
        hasCompletedOnboarding = true
    }
}
