import SwiftUI
import SwiftData

@main
struct MyCareLayerApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: UserProfile.self)
    }
}
