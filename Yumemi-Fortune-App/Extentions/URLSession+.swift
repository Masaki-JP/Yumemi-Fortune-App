import Foundation

extension URLSession {
    enum Mock {
        case fortuneAPI
    }

    static func mock(for mock: Mock) -> URLSession {
        switch mock {
        case .fortuneAPI:
            Self.createMockForFortuneAPI()
        }
    }

    private static func createMockForFortuneAPI() -> URLSession {
        guard
            let url = URL(string: "https://ios-junior-engineer-codecheck.yumemi.jp/my_fortune"),
            let data = try? JSONEncoder().encode(FortuneAPIResponse.sample),
            let response: HTTPURLResponse = .init(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        else {
            fatalError()
        }

        var targets: [URL: (error: Swift.Error?, data: Data?, response: HTTPURLResponse?)] = .init()
        targets[url] = (error: nil, data: data, response: response)

        FortuneAPIClient.FortuneAPIURLProtocol.targets = targets

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [FortuneAPIClient.FortuneAPIURLProtocol.self]

        return .init(configuration: config)
    }
}
