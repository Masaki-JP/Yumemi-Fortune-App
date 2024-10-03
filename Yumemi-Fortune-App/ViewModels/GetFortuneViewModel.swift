import SwiftUI
import SwiftData

/// ``GetFortuneView``で使用するViewModel。
///
@MainActor @Observable
final class GetFortuneViewModel<FortuneFetcherObject: FortuneFetcherProtocol & Sendable> {
    let user: User
    let modelContext: ModelContext

    private let fortuneFetcher: FortuneFetcherObject
    private let drumRollPlayer = DrumRollPlayer()

    /// ``WaveTextView``の表示フラグ。
    ///
    private(set) var isShowingWaveTextView = true

    /// ラッキー都道府県の`Text`の表示フラグ。
    ///
    private(set) var isShowingCompatiblePrefectureText = false

    /// 「前の画面に戻る」ボタンの表示フラグ。
    ///
    private(set) var isShowingDismissButton = false

    /// エラー発生時のアラートの表示フラグとなる文字列。
    ///
    private(set) var errorAlertMessage = ""

    /// `errorAlertMessage`のバインディング。
    ///
    var errorAlertMessageBinding: Binding<Bool> {
        .init(
            get: { self.errorAlertMessage.isEmpty == false },
            set: { if $0 == false { self.errorAlertMessage.removeAll() } }
        )
    }

    init(user: User, modelContext: ModelContext, fortuneFetcher: FortuneFetcherObject = FortuneFetcher()) {
        self.user = user
        self.modelContext = modelContext
        self.fortuneFetcher = fortuneFetcher
    }

    /// `View`が表示された時に実行される処理。
    ///
    func onAppearAction() async {
        do {
            /// ``FortuneResult``の取得を行う。失敗時は早期リターンする。
            let fortuneResult = try await fortuneFetcher.fetch(name: user.name, birthday: user.birthday, bloodType: user.bloodType)

            /// ドラムロールの再生を開始する。
            drumRollPlayer.play()

            /// 5.5秒の遅延の後に``WaveTextView``を非表示にする。
            try? await Task.sleep(for: .seconds(5.5))
            withAnimation { isShowingWaveTextView = false }

            /// 0.5秒の遅延の後にラッキー都道府県の`Text`を表示し、``User``に``FortuneResult``を追加する。
            try? await Task.sleep(for: .seconds(0.5))
            withAnimation { isShowingCompatiblePrefectureText = true }
            user.addFortuneResult(fortuneResult)
            guard let _ = try? modelContext.save() else {
                errorAlertMessage = "予期せぬエラーが発生しました。"; return
            }

            /// 2.0秒の遅延の後に「前の画面に戻る」ボタンを表示する。
            try? await Task.sleep(for: .seconds(2.0))
            withAnimation { isShowingDismissButton = true }
        } catch {
            switch error { /// ``FortuneFetchError``
            case .possibleNetworkError:
                errorAlertMessage = "ネットワークエラーが発生しました。"
            case .noName, .tooLongName, .invalidBirthday, .urlInitializeFailure, .encodeFailure, .unexpectedResponse, .decodeFailure, .unexpectedError(_):
                errorAlertMessage = "予期せぬエラーが発生しました。"
            }
        }
    }
}
