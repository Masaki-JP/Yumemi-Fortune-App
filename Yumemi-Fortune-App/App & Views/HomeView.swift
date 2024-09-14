import SwiftUI
import SwiftData

@MainActor
struct HomeView: View {
    @State private var viewModel: HomeViewModel

    init(user: User, modelContext: ModelContext) {
        self._viewModel = .init(wrappedValue: .init(user: user, modelContext: modelContext))
    }

    var body: some View {
        NavigationStack {
            VStack {
                if let todayFortune = viewModel.user.todayFortune {
                    Text("今日のラッキー都道府県は")
                    Text(todayFortune.compatiblePrefecture + "です！")
                    Button("詳しく見る") {}
                } else {
                    fortunePromptView(action: viewModel.didTapGetFortuneButtonInHomeView)
                }
            }
            .navigationTitle("ホーム")
            .toolbarTitleDisplayMode(.inlineLarge)
            .fullScreenCover(isPresented: $viewModel.isShowingGetFortuneView) {
                GetFortuneView(user: viewModel.user)
            }
        }
    }
}

private struct HomeViewWrapper_Case1: View {
    @Environment(\.modelContext) private var modelContext
    let user = User(
        name: "Naruto",
        birthday: .today,
        bloodType: .a,
        fortuneResults: [.today: .sample1]
    )

    var body: some View {
        HomeView(user: user, modelContext: modelContext)
    }
}

private struct HomeViewWrapper_Case2: View {
    @Environment(\.modelContext) private var modelContext
    let user = User(name: "Naruto", birthday: .today, bloodType: .a)

    var body: some View {
        HomeView(user: user, modelContext: modelContext)
    }
}

#Preview("Case1") {
    HomeViewWrapper_Case1()
}

#Preview("Case2") {
    HomeViewWrapper_Case2()
}
