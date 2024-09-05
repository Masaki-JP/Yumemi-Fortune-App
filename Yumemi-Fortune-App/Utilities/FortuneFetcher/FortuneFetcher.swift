import Foundation

struct FortuneFetcher: FortuneFetcherProtocol {
    private let urlSession: URLSession

    init(_ urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    private struct RequestBody: Encodable {
        let name: String
        let birthday: Day
        let blood_type: BloodType
        let today: Day
    }

    enum FetchError: Swift.Error {
        case noName
        case tooLongName
        case invalidBirthday
        case urlInitializeFailure
        case encodeFailure
        case possibleNetworkError
        case unexpectedResponse
        case decodeFailure
        case unexpectedError(_ messege: String)
    }

    func fetch(name: String, birthday: Day, bloodType: BloodType) async throws -> FortuneResult {
        /// 引数のバリデーション
        guard name.isEmpty == false else { throw Self.FetchError.noName }
        guard name.count < 100 else { throw Self.FetchError.tooLongName }
        guard birthday <= Day.today else { throw Self.FetchError.invalidBirthday }

        /// URLインスタンスの作成
        let baseURLString = "https://ios-junior-engineer-codecheck.yumemi.jp"
        let endPointPathString = "/my_fortune"
        guard let url = URL(string: baseURLString + endPointPathString) else {
            throw Self.FetchError.urlInitializeFailure
        }

        /// RequestBodyの生成
        let requestBody = RequestBody(name: name, birthday: birthday, blood_type: bloodType, today: .today)

        /// RequestBodyからDataを生成
        guard let encodedJsonData = try? JSONEncoder().encode(requestBody) else {
            throw Self.FetchError.encodeFailure
        }

        /// URLReuestの作成
        let request = makeURLRequest(url, httpBody: encodedJsonData)

        /// DataとURLResponseの取得
        guard let (data, urlResponse) = try? await urlSession.data(for: request) else {
            throw Self.FetchError.possibleNetworkError
        }

        /// 有効なレスポンスであるか確認
        guard let httpURLResponse = urlResponse as? HTTPURLResponse,
              (200...299).contains(httpURLResponse.statusCode) else {
            throw Self.FetchError.unexpectedResponse
        }

        /// DataからFortuneResultを生成
        guard let fortuneResult = try? JSONDecoder().decode(FortuneResult.self, from: data) else {
            throw Self.FetchError.decodeFailure
        }

        /// FortuneResultをリターン
        return fortuneResult
    }

    private func makeURLRequest(_ url: URL, httpBody: Data) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("v1", forHTTPHeaderField: "API-Version")
        request.httpBody = httpBody

        return request
    }
}
