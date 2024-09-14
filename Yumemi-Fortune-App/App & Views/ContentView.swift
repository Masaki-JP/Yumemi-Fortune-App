import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    let user: User

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

#Preview {
    ContentView(user: .init(name: "Naruto", birthday: .today, bloodType: .a))
}
