import SwiftUI

@MainActor
struct GetFortuneView: View {
    @State private var viewModel: GetFortuneViewModel
    @Environment(\.dismiss) private var dismiss

    init(user: User) {
        self._viewModel = .init(wrappedValue: .init(user: user))
    }

    var body: some View {
        if let todayFortune = viewModel.user.fortuneResultList.first(where: { $0.key == .today })?.value {
            VStack {
                Text("今日のラッキー都道府県は\(todayFortune.compatiblePrefecture)です！")
                Button("戻る", action: dismiss.callAsFunction)
            }
        } else {
            Button("今日の占いを取得", action: viewModel.didTapGetFortuneButton)
        }
    }
}

private struct GetFortuneViewWrapper: View {
    private let user = User(name: "Naruto", birthday: .sample, bloodType: .a)
    @State private var isShowingGetFortuneView = true

    var body: some View {
        Button("占い取得画面に遷移") {
            isShowingGetFortuneView = true
        }
        .fullScreenCover(isPresented: $isShowingGetFortuneView) {
            GetFortuneView(user: user)
        }
    }
}

#Preview {
    GetFortuneViewWrapper()
}
