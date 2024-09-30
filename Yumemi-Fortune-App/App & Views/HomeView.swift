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
                    VStack(spacing: 5) {
                        Text("今日のラッキー都道府県は")
                        Image(.fortuneTeller)
                            .resizable().scaledToFit()
                            .frame(width: 250, height: 250)
                        Text(todayFortune.compatiblePrefecture + "です！")
                    }
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay(alignment: .bottom) {
                        NavigationLink("詳しい情報を見る") {
                            FortuneResultView(todayFortune)
                                .navigationTitle(Day.today.japaneseFormatted)
                                .navigationBarTitleDisplayMode(.inline)
                        }
                        .padding(.bottom, 5)
                    }
                } else {
                    fortunePromptView(action: viewModel.didTapGetFortuneButtonInHomeView)
                }
            }
            .navigationTitle("ホーム")
            .toolbarTitleDisplayMode(.inlineLarge)
            .fullScreenCover(isPresented: $viewModel.isShowingGetFortuneView) {
                GetFortuneView(user: viewModel.user, modelContext: viewModel.modelContext)
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
