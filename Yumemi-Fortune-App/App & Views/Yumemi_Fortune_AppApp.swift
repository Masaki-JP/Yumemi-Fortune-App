import SwiftUI
import SwiftData

@main
struct Yumemi_Fortune_AppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([User.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            Text("Hello, world.")
        }
    }
}
