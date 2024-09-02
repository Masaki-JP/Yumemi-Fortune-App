import SwiftUI

@MainActor
final class ContentViewModel<FortuneAPIClientObject: FortuneAPIClientProtocol & Sendable>: ObservableObject {

    @Published var name = ""
    @Published var birthday: Date = .init()
    @Published var bloodType: BloodType? = nil
    @Published var fortuneAPIResponse: FortuneAPIResponse? = nil {
        didSet { fetchFortuneTask = nil }
    }

    private let fortuneAPIClient: FortuneAPIClientObject
    @Published private var fetchFortuneTask: Task<Void, Never>? = nil
    var isFetchingFortune: Bool { fetchFortuneTask != nil }

    var isGetFortuneButtonDisabled: Bool {
        !(name.isEmpty == false && bloodType != nil)
    }

    @Published private(set) var alertMessage: String? = nil {
        didSet { 
            fetchFortuneTask = nil

            if alertMessage != nil {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
        }
    }
    var alertMessageBinding: Binding<Bool> {
        .init(get: { self.alertMessage != nil },
              set: { if $0 == false { self.alertMessage = nil }})
    }

    init(fortuneAPIClient: FortuneAPIClientObject = FortuneAPIClient()) {
        self.fortuneAPIClient = fortuneAPIClient
    }

    deinit {
        Task { @MainActor [weak self] in
            self?.fetchFortuneTask?.cancel()
        }
    }

    func didTapFortuneButton() {
        fetchFortuneTask = .init {
            do {
                let birthday = Day(birthday)
                guard let bloodType else { alertMessage = "予期せぬエラーが発生しました。"; return; }

                fortuneAPIResponse = try await fortuneAPIClient.fetchFortune(name: name, birthday: birthday, bloodType: bloodType)
            } catch {
                if case FortuneAPIClient.Error.tooLongName = error  {
                    alertMessage = "名前は100文字未満にしてください。"
                } else {
                    alertMessage = "予期せぬエラーが発生しました。"
                }
            }
        }
    }

    private func cancelFetchFortuneTask() { fetchFortuneTask?.cancel() }
    func onChangeToNotActive() { cancelFetchFortuneTask() }
    func onDisAppear() { cancelFetchFortuneTask() }
}
