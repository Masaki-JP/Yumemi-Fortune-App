import Foundation
import SwiftData

@MainActor @Observable
final class FortuneResultListViewModel {

    /// Access Level
    let user: User
    let modexContext: ModelContext

    var isShowingGetFortuneResultView = false

    init(user: User, modexContext: ModelContext) {
        self.user = user
        self.modexContext = modexContext
    }

    func didTapGetFortuneButton() {
        isShowingGetFortuneResultView = true
    }
}
