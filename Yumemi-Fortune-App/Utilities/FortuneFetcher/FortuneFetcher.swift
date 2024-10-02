import Foundation

/// 占い結果を取得するオブジェクト。
///
/// ``fetch(name:birthday:bloodType:)``メソッドで``FortuneResult``を取得できる。
///
/// >note:
/// 初期化時にURLSessionのモックが可能。
///
struct FortuneFetcher: FortuneFetcherProtocol {
    private let urlSession: URLSession

    /// ``FortuneFetcher``のイニシャライザ。
    /// - Parameter urlSession: 内部で使用する``Foundation/URLSession``を指定する。デフォルト引数として`.shared`が設定されている。
    ///
    init(_ urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    private struct RequestBody: Encodable {
        let name: String
        let birthday: Day
        let blood_type: BloodType
        let today: Day
    }

    /// ``FortuneResult``を取得するメソッド。
    ///
    /// FortuneAPIから``FortuneResult``を非同期で取得する。このメソッドが投げる可能性のあるエラーは現状``FortuneFetchError``のみで。
    ///
    /// FortuneAPI: [https://ios-junior-engineer-codecheck.yumemi.jp/my_fortune](https://ios-junior-engineer-codecheck.yumemi.jp/my_fortune)
    ///
    /// - Parameters:
    ///   - name: ユーザーの名前を指定する。
    ///   - birthday: ユーザーの誕生日を指定する。
    ///   - bloodType: ユーザーの血液型を指定する。
    /// - Returns: 取得した``FortuneResult``を返す。
    ///
    func fetch(name: String, birthday: Day, bloodType: BloodType) async throws(FortuneFetchError) -> FortuneResult {
        /// 引数のバリデーション
        guard name.isEmpty == false else { throw .noName }
        guard name.count < 100 else { throw .tooLongName }
        guard birthday <= Day.today else { throw .invalidBirthday }

        /// URLインスタンスの作成
        let baseURLString = "https://ios-junior-engineer-codecheck.yumemi.jp"
        let endPointPathString = "/my_fortune"
        guard let url = URL(string: baseURLString + endPointPathString) else {
            throw .urlInitializeFailure
        }

        /// RequestBodyの生成
        let requestBody = RequestBody(name: name, birthday: birthday, blood_type: bloodType, today: .today)

        /// RequestBodyからDataを生成
        guard let encodedJsonData = try? JSONEncoder().encode(requestBody) else {
            throw .encodeFailure
        }

        /// URLReuestの作成
        let request = makeURLRequest(url, httpBody: encodedJsonData)

        /// DataとURLResponseの取得
        guard let (data, urlResponse) = try? await urlSession.data(for: request) else {
            throw .possibleNetworkError
        }

        /// 有効なレスポンスであるか確認
        guard let httpURLResponse = urlResponse as? HTTPURLResponse,
              (200...299).contains(httpURLResponse.statusCode) else {
            throw .unexpectedResponse
        }

        /// DataからFortuneResultを生成
        guard let fortuneResult = try? JSONDecoder().decode(FortuneResult.self, from: data) else {
            throw .decodeFailure
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
