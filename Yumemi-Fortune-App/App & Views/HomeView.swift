import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var viewModel: HomeViewModel

    init(user: User, modelContext: ModelContext) {
        self._viewModel = .init(wrappedValue: .init(user: user, modelContext: modelContext))
    }

    var body: some View {
        NavigationStack {
            VStack {
                if let todayFortune = viewModel.user.todayFortune {
                    todayFortuneResult(todayFortune)
                } else {
                    fortunePromptView(action: viewModel.didTapGetFortuneButton)
                }
            }
            .navigationTitle("ホーム")
            .toolbarTitleDisplayMode(.inlineLarge)
            .fullScreenCover(isPresented: $viewModel.isShowingGetFortuneView) {
                GetFortuneView(user: viewModel.user, modelContext: viewModel.modelContext)
            }
        }
    }

    @ViewBuilder
    func todayFortuneResult(_ todayFortune: FortuneResult) -> some View {
        VStack(spacing: 15) {
            Text("今日のラッキー都道府県は\n")
                .font(.title)
                .fontWeight(.semibold)
            + Text(todayFortune.compatiblePrefecture)
                .font(.largeTitle)
                .fontWeight(.black)
            +  Text("です！")
                .font(.title)
                .fontWeight(.semibold)

            Image(.fortuneTeller)
                .resizable().scaledToFit()
                .frame(width: 250, height: 250)

            NavigationLink("詳しい情報を見る") {
                FortuneResultView(todayFortune)
                    .navigationTitle(Day.today.japaneseFormatted)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .fontWeight(.semibold)
        }
        .multilineTextAlignment(.center)
        .lineSpacing(5.0)
    }
}

private struct HomeViewWrapper_Case1: View {
    @Environment(\.modelContext) private var modelContext
    let user = try! User(
        name: "Naruto",
        birthday: .today,
        bloodType: .a,
        fortuneResultList: [.today: .sample1]
    )

    var body: some View {
        HomeView(user: user, modelContext: modelContext)
    }
}

private struct HomeViewWrapper_Case2: View {
    @Environment(\.modelContext) private var modelContext
    let user = try! User(name: "Naruto", birthday: .today, bloodType: .a)

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
