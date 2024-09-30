import SwiftUI
import SwiftData

// 要リファクタ
@MainActor @Observable
final class GetFortuneViewModel<FortuneFetcherObject: FortuneFetcherProtocol & Sendable> {
    private(set) var isShowingWaveTextView = true
    private(set) var isShowingCompatiblePrefectureText = false
    private(set) var isShowingDismissButton = false

    var isShowingUnknownErrorAlert = false

    let user: User
    let modelContext: ModelContext

    private let fortuneFetcher: FortuneFetcherObject
    private let drumRollPlayer = DrumRollPlayer()

    init(user: User, modelContext: ModelContext, fortuneFetcher: FortuneFetcherObject = FortuneFetcher()) {
        self.user = user
        self.modelContext = modelContext
        self.fortuneFetcher = fortuneFetcher
    }

    func onAppearAction() async {
        do {
            guard let fortuneResult = try? await fortuneFetcher.fetch(
                name: user.name,
                birthday: user.birthday,
                bloodType: user.bloodType
            ) else { return }

            drumRollPlayer.play()

            try? await Task.sleep(for: .seconds(5.5))
            withAnimation { isShowingWaveTextView = false }

            try? await Task.sleep(for: .seconds(0.5))
            withAnimation { isShowingCompatiblePrefectureText = true }
            user.addFortuneResult(fortuneResult)
            try modelContext.save()

            try? await Task.sleep(for: .seconds(2.0))
            withAnimation { isShowingDismissButton = true }
        } catch {
            isShowingUnknownErrorAlert = true
        }
    }
}
