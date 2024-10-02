import SwiftUI
import SwiftData

struct ContentView: View {
    private let user: User
    private var modelContext: ModelContext

    init(user: User, modelContext: ModelContext) {
        self.user = user
        self.modelContext = modelContext
    }

    var body: some View {
        TabView {
            HomeView(user: user, modelContext: modelContext)
                .tabItem { Label("ホーム", systemImage: "house") }
            FortuneResultListView(user: user, modelContext: modelContext)
                .tabItem { Label("過去の占い", systemImage: "list.bullet") }
            SettingListView(user: user, modelContext: modelContext)
                .tabItem { Label("ユーザー設定", systemImage: "gear") }
        }
    }
}

private struct ContentViewWrapper: View {
    private let user = try! User(name: "Naruto", birthday: .sample, bloodType: .a)
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ContentView(user: user, modelContext: modelContext)
    }
}

#Preview {
    ContentViewWrapper()
}
