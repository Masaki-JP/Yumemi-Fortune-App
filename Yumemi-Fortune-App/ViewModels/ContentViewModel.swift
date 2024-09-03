import SwiftUI

@MainActor @Observable
final class ContentViewModel<FortuneAPIClientObject: FortuneAPIClientProtocol & Sendable> {

    var name = ""
    var birthday: Date = .init()
    var bloodType: BloodType? = nil
    var fortuneAPIResponse: FortuneAPIResponse? = nil

    private let fortuneAPIClient: FortuneAPIClientObject
    private var fetchFortuneTask: Task<Void, Never>? = nil
    var isFetchingFortune: Bool { fetchFortuneTask != nil }

    var isGetFortuneButtonDisabled: Bool {
        !(name.isEmpty == false && bloodType != nil)
    }

    private(set) var alertMessage: String? = nil {
        didSet {
            if alertMessage != nil {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
        }
    }

    var alertMessageBinding: Binding<Bool> {
        .init(get: { [weak self] in self?.alertMessage != nil },
              set: { [weak self] in if $0 == false { self?.alertMessage = nil }})
    }

    nonisolated init(fortuneAPIClient: FortuneAPIClientObject = FortuneAPIClient()) {
        self.fortuneAPIClient = fortuneAPIClient
    }

    deinit {
        Task { @MainActor [weak self] in
            self?.fetchFortuneTask?.cancel()
        }
    }

    func didTapGetFortuneButton() {
        fetchFortuneTask = .init {
            do {
                guard let bloodType else {
                    alertMessage = "予期せぬエラーが発生しました。"; return;
                }

                fortuneAPIResponse = try await fortuneAPIClient.fetchFortune(
                    name: name,
                    birthday: .init(birthday),
                    bloodType: bloodType
                )
            } catch {
                if case FortuneAPIClient.Error.tooLongName = error  {
                    alertMessage = "名前は100文字未満にしてください。"
                } else {
                    alertMessage = "予期せぬエラーが発生しました。"
                }
            }

            fetchFortuneTask = nil
        }
    }

    private func cancelFetchFortuneTask() { fetchFortuneTask?.cancel() }
    func onChangeToNotActive() { cancelFetchFortuneTask() }
    func onDisAppear() { cancelFetchFortuneTask() }
}
