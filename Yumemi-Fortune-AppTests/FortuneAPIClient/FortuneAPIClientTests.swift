import XCTest
@testable import Yumemi_Fortune_App

final class FortuneAPIClientTests: XCTestCase {

    var fortuneAPIClient: FortuneAPIClient!

    func test_正常系_有効な引数が与えられた時に問題なく動作すること() async {
        let fortuneAPIResponse = try? await fortuneAPIClient.fetchFortune(
            name: "Sasuke",
            birthday: .sample,
            bloodType: .a)

        XCTAssertNotNil(fortuneAPIResponse, "有効な引数が与えられたのにも関わらずFortuneAPIResponseの取得に失敗している。")
    }

    func test_異常系_引数nameに空文字が与えられた時に適切なエラーを投げること() async {
        do {
            let fortuneAPIResponse = try await fortuneAPIClient.fetchFortune(
                name: "", // Empty String
                birthday: .sample,
                bloodType: .a)

            XCTFail("エラーが投げられていない。")
        } catch {
            guard case FortuneAPIClient.Error.noName = error else {
                XCTFail("適切なエラーが投げられていない。"); return;
            }
        }
    }

    func test_異常系_引数nameに100文字以上の文字列が与えられた時に適切なエラーを投げること() async {
        let name: String = .init(repeating: "A", count: 101)

        do {
            let fortuneAPIResponse = try await fortuneAPIClient.fetchFortune(
                name: name,
                birthday: .sample,
                bloodType: .a)

            XCTFail("エラーが投げられていない。")
        } catch {
            guard case FortuneAPIClient.Error.tooLongName = error else {
                XCTFail("適切なエラーが投げられていない。"); return;
            }
        }
    }
}

extension FortuneAPIClientTests {

    override func setUpWithError() throws {
        let fortuneAPIResponseSample = FortuneAPIResponse.sample

        guard
            let url = URL(string: "https://ios-junior-engineer-codecheck.yumemi.jp/my_fortune"),
            let data = try? JSONEncoder().encode(fortuneAPIResponseSample),
            let response: HTTPURLResponse = .init(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        else {
            XCTFail("An issue unrelated to the test subject has occurred."); return;
        }

        var targets: [URL: (error: Swift.Error?, data: Data?, response: HTTPURLResponse?)] = .init()
        targets[url] = (error: nil, data: data, response: response)

        fortuneAPIClient = .init(.mock(for: .fortuneAPI(targets)))
    }
}
