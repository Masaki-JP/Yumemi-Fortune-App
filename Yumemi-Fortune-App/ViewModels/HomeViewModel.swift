import Foundation
import SwiftData

@MainActor @Observable
final class HomeViewModel {
    let user: User
    let modelContext: ModelContext

    var isShowingGetFortuneView = false

    init(user: User, modelContext: ModelContext) {
        self.user = user
        self.modelContext = modelContext
    }

    func didTapGetFortuneButtonInHomeView() {
        isShowingGetFortuneView = true
    }
}
