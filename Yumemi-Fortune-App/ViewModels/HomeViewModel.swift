import Foundation
import SwiftData

/// ``HomeView``で使用するViewModel。
///
@MainActor @Observable
final class HomeViewModel {
    let user: User
    let modelContext: ModelContext

    /// ``GetFortuneView``の表示フラグ。
    ///
    var isShowingGetFortuneView = false

    init(user: User, modelContext: ModelContext) {
        self.user = user
        self.modelContext = modelContext
    }

    /// 「占う」ボタンが押された時の処理。
    ///
    /// フルスクリーンで``GetFortuneView``を表示する。
    ///
    func didTapGetFortuneButton() {
        isShowingGetFortuneView = true
    }
}
