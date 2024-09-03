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
            let alertMessageForUnexpectedError = "予期せぬエラーが発生しました。"

            do {
                guard let bloodType else {
                    /// bloodTypeがnilの場合に占うボタンは押せないため、bloodTypeのアンラップに失敗することは理論上ない。
                    alertMessage = alertMessageForUnexpectedError; return;
                }

                fortuneAPIResponse = try await fortuneAPIClient.fetchFortune(
                    name: name,
                    birthday: .init(birthday),
                    bloodType: bloodType
                )
            } catch let error as FortuneAPIClient.Error {
                switch error {
                case .tooLongName:
                    alertMessage = "名前は100文字未満にしてください。"
                case .noName, .invalidBirthday: // ※1
                    alertMessage = alertMessageForUnexpectedError
                case .urlInitializeFailure, .encodeFailure, .possibleNetworkError, .unexpectedResponse, .decodeFailure, .unexpectedError:
                    alertMessage = alertMessageForUnexpectedError
                }
            } catch {
                alertMessage = alertMessageForUnexpectedError
            }

            fetchFortuneTask = nil
        }
    }

    private func cancelFetchFortuneTask() { fetchFortuneTask?.cancel() }
    func onChangeToNotActive() { cancelFetchFortuneTask() }
    func onDisAppear() { cancelFetchFortuneTask() }
}

/// ※1: 空文字の場合に占うボタンは押せないため、noNameが投げられることは理論上ない。また、DatePickerで指定できる日付を当日以前に限定しているため、invalidBirthdayも投げられることは理論上ない。
