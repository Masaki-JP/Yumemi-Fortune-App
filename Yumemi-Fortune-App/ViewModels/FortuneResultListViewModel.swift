import Foundation
import SwiftData

/// ``FortuneResultListView``で使用するViewModel。
///
@MainActor @Observable
final class FortuneResultListViewModel {
    let user: User
    let modexContext: ModelContext

    /// ``GetFortuneView``の表示フラグ。
    ///
    var isShowingGetFortuneResultView = false

    init(user: User, modexContext: ModelContext) {
        self.user = user
        self.modexContext = modexContext
    }

    /// 「占う」ボタンを押された時の処理。
    ///
    /// フルスクリーンで``GetFortuneView``を表示する。
    ///
    func didTapGetFortuneButton() {
        isShowingGetFortuneResultView = true
    }
}
