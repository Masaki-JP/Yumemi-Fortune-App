import Foundation
import SwiftData

@MainActor @Observable
final class FortuneResultListViewModel<FortuneFetcherObject: FortuneFetcherProtocol & Sendable> {
    
    /// Access Level
    let user: User
    let modexContext: ModelContext
    let fortuneFetcher: FortuneFetcherObject

    var isShowingGetFortuneResultView = false

    init(
        user: User,
        modexContext: ModelContext,
        fortuneFetcher: FortuneFetcherObject = FortuneFetcher()
    ) {
        self.user = user
        self.modexContext = modexContext
        self.fortuneFetcher = fortuneFetcher
    }

    func didTapGetFortuneButton() {
        isShowingGetFortuneResultView = true
    }
}
