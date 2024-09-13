import Foundation

extension URLSession {

    /// ``URLSession``のモックを作成できるケース群。
    enum Mock {
        case fortuneAPI
    }

    /// ``URLSession``のモックを作成するメソッド。
    /// - Parameter mock: 通信先を``Mock``を用いて指定する。
    /// - Returns: 作成された``URLSession``のモックを返す。
    ///
    static func mock(for mock: Mock) -> URLSession {
        switch mock {
        case .fortuneAPI:
            Self.createMockForFortuneAPI()
        }
    }

    private static func createMockForFortuneAPI() -> URLSession {
        guard
            let url = URL(string: "https://ios-junior-engineer-codecheck.yumemi.jp/my_fortune"),
            let data = try? JSONEncoder().encode(FortuneResult.sample1),
            let response: HTTPURLResponse = .init(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        else {
            fatalError()
        }

        var targets: [URL: (error: Swift.Error?, data: Data?, response: HTTPURLResponse?)] = .init()
        targets[url] = (error: nil, data: data, response: response)

        FortuneFetcher.FortuneAPIURLProtocol.targets = targets

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [FortuneFetcher.FortuneAPIURLProtocol.self]

        return .init(configuration: config)
    }
}
