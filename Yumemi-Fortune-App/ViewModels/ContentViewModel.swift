import Foundation

@MainActor
final class ContentViewModel: ObservableObject {

    @Published var name = ""
    @Published var birthday: Date = .init()
    @Published var bloodType: BloodType? = nil
    @Published var fortuneAPIResponse: FortuneAPIResponse? = nil
    @Published var fortuneAPIClientError: FortuneAPIClient.Error? = nil
    @Published var unSetBloodTypeErrorAlert = false
    @Published var unexpectedErrorAlert = false

    func didTapFortuneButton() {
        Task {
            do {
                let apiClient = FortuneAPIClientStub(.failure(.decodeFailure))
                let birthday = Day(birthday)
                guard let bloodType else {
                    unSetBloodTypeErrorAlert = true
                    return
                }

                fortuneAPIResponse = try await apiClient.fetchFortune(
                    name: name,
                    birthday: birthday,
                    bloodType: bloodType
                )
            } catch let error as FortuneAPIClient.Error {
                fortuneAPIClientError = error
            } catch {
                fatalError()
            }
        }
    }

    func alertMessage(_ fortuneAPIClientError: FortuneAPIClient.Error) -> String {
        switch fortuneAPIClientError {
        case .noName:
            "名前を入力してください。"
        case .tooLongName:
            "入力された名前が長すぎます。名前は〇文字以上〇文字以下にしてください。"
        case .possibleNetworkError:
            "占い結果を受信できませんでした。ネットワーク状態のいい場所に移動すると、このエラーは解消される可能性があります。"
        case .invalidBirthday, .urlInitializeFailure, .encodeFailure, .unexpectedResponse, .decodeFailure, .unexpectedError:
            "予期せぬエラーが発生しました。"
        }
    }
}
