import Foundation
import SwiftData

/// ``FortuneResultListView``で使用するViewModel。
///
@MainActor @Observable
final class FortuneResultListViewModel {
    let user: User
    let modelContext: ModelContext

    /// ``GetFortuneView``の表示フラグ。
    ///
    var isShowingGetFortuneView = false

    init(user: User, modelContext: ModelContext) {
        self.user = user
        self.modelContext = modelContext
    }

    /// 「占う」ボタンを押された時の処理。
    ///
    /// フルスクリーンで``GetFortuneView``を表示する。
    ///
    func didTapGetFortuneButton() {
        isShowingGetFortuneView = true
    }
}
