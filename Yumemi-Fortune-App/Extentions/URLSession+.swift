import Foundation

extension URLSession {
    enum Mock {
        case fortuneAPI(_ targets: [URL: (error: Error?, data: Data?, response: HTTPURLResponse?)])
    }

    static func mock(for mock: Mock) -> URLSession {
        switch mock {
        case .fortuneAPI(let targets):
            Self.createMockForFortuneAPI(targets)
        }
    }

    private static func createMockForFortuneAPI(_ targets: [URL: (error: Error?, data: Data?, response: HTTPURLResponse?)]) -> URLSession {
        FortuneAPIClient.FortuneAPIURLProtocol.targets = targets

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [FortuneAPIClient.FortuneAPIURLProtocol.self]

        return .init(configuration: config)
    }
}
