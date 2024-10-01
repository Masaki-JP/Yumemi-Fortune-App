import SwiftUI
import SwiftData
import Pow

struct GetFortuneView<FortuneFetcherObject: FortuneFetcherProtocol & Sendable>: View {
    @State private var viewModel: GetFortuneViewModel<FortuneFetcherObject>
    @Environment(\.dismiss) private var dismiss

    init(
        user: User,
        modelContext: ModelContext,
        fortuneFetcher: FortuneFetcherObject = FortuneFetcher()
    ) {
        self._viewModel = .init(wrappedValue: .init(user: user, modelContext: modelContext, fortuneFetcher: fortuneFetcher))
    }

    var body: some View {
        VStack(spacing: .zero) {
            if viewModel.isShowingWaveTextView == true {
                WaveTextView("今日のラッキー都道府県は…")
            }
            if viewModel.isShowingCompatiblePrefectureText == true {
                if let compatiblePrefecture = viewModel.user.todayFortune?.compatiblePrefecture {
                    Text(compatiblePrefecture + "です！")
                        .font(.system(size: 40))
                        .fontWeight(.semibold)
                        .transition(.identity.animation(.linear(duration: 1).delay(2)).combined(with: .movingParts.anvil))
                        .overlay(alignment: .bottom) {
                            if viewModel.isShowingDismissButton == true {
                                Button("前の画面に戻る", action: dismiss.callAsFunction)
                                    .offset(y: 30.0)
                            }
                        }
                } else {
                    VStack(spacing: nil) {
                        Text("エラーが発生しました。前の画面に戻ってからもう一度お試しください。")
                        Button("前の画面に戻る", action: dismiss.callAsFunction)
                    }
                }
            }
        }
        .task { await viewModel.onAppearAction() }
        .alert(
            "予期せぬエラーが発生しました。",
            isPresented: $viewModel.isShowingUnexpectedErrorAlert,
            actions: {}
        )
    }
}

private struct GetFortuneViewWrapper: View {
    private let user = User(name: "Naruto", birthday: .sample, bloodType: .a)
    @State private var isShowingGetFortuneView = true
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Button("占い取得画面に遷移") {
            isShowingGetFortuneView = true
        }
        .fullScreenCover(isPresented: $isShowingGetFortuneView) {
            GetFortuneView(user: user, modelContext: modelContext, fortuneFetcher: FortuneFetcher(.mock(for: .fortuneAPI)))
        }
    }
}

#Preview {
    GetFortuneViewWrapper()
}
