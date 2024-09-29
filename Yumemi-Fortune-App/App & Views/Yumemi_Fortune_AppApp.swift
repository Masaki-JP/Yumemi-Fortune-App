import SwiftUI
import SwiftData

@main
struct Yumemi_Fortune_AppApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .modelContainer(for: User.self, isAutosaveEnabled: false)
        }
    }
}
