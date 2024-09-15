import SwiftUI

// 要リファクタ
@MainActor @Observable
final class GetFortuneViewModel<FortuneFetcherObject: FortuneFetcherProtocol & Sendable> {
    private(set) var isShowingWaveTextView = true
    private(set) var isShowingCompatiblePrefectureText = false
    private(set) var isShowingDismissButton = false

    let user: User
    private let fortuneFetcher: FortuneFetcherObject
    private let drumRollPlayer = DrumRollPlayer()

    init(user: User, fortuneFetcher: FortuneFetcherObject = FortuneFetcher(.mock(for: .fortuneAPI))) {
        self.user = user
        self.fortuneFetcher = fortuneFetcher
    }

    func onAppearAction() async {
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

        try? await Task.sleep(for: .seconds(2.0))
        withAnimation { isShowingDismissButton = true }
    }
}
