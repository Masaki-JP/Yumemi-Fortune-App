import Foundation

extension FortuneFetcher {

    final class FortuneAPIURLProtocol: URLProtocol {

        /// テスト時のみ用いられることから`nonisolated(unsafe)`を付与し、Warningを回避する。
        nonisolated(unsafe) static var targets: [URL: (error: Swift.Error?, data: Data?, response: HTTPURLResponse?)] = .init()

        override class func canInit(with request: URLRequest) -> Bool { true }

        override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

        override func startLoading() {
            if let url = request.url, let (error, data, response) = Self.targets[url]  {
                if let response { self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed) }
                if let data { self.client?.urlProtocol(self, didLoad: data) }
                if let error { self.client?.urlProtocol(self, didFailWithError: error) }
            }

            self.client?.urlProtocolDidFinishLoading(self)
        }

        override func stopLoading() {}
    }
}
