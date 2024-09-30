import SwiftUI
import SwiftData

struct RootView: View {
    @Query private var users: [User]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        switch users.count {
        case 1:
            ContentView(user: users.first!, modelContext: modelContext)
        case 0:
            ProfileRegisterView(modelContext: modelContext)
        default:
            Text("エラーが発生しました。")
        }
    }
}

#Preview {
    RootView()
        .modelContainer(for: User.self, inMemory: true)
}
