import XCTest
@testable import Yumemi_Fortune_App

final class FortuneAPIClientTests: XCTestCase {

    var fortuneAPIClient: FortuneFetcher!

    override func setUpWithError() throws {
        fortuneAPIClient = .init(.mock(for: .fortuneAPI))
    }

    func test_正常系_有効な引数が与えられた時に問題なく動作すること() async {
        let fortuneAPIResponse = try? await fortuneAPIClient.fetchFortune(
            name: "Sasuke",
            birthday: .sample,
            bloodType: .a)

        XCTAssertNotNil(fortuneAPIResponse, "有効な引数が与えられたのにも関わらずFortuneAPIResponseの取得に失敗している。")
    }

    func test_異常系_引数nameに空文字が与えられた時に適切なエラーを投げること() async {
        do {
            let _ = try await fortuneAPIClient.fetchFortune(
                name: "", // Empty String
                birthday: .sample,
                bloodType: .a)

            XCTFail("エラーが投げられていない。")
        } catch {
            guard case FortuneFetcher.Error.noName = error else {
                XCTFail("適切なエラーが投げられていない。"); return;
            }
        }
    }

    func test_異常系_引数nameに100文字以上の文字列が与えられた時に適切なエラーを投げること() async {
        let name: String = .init(repeating: "A", count: 101)

        do {
            let _ = try await fortuneAPIClient.fetchFortune(
                name: name,
                birthday: .sample,
                bloodType: .a)

            XCTFail("エラーが投げられていない。")
        } catch {
            guard case FortuneFetcher.Error.tooLongName = error else {
                XCTFail("適切なエラーが投げられていない。"); return;
            }
        }
    }

    func test_フレイキーテスト_実際にFortuneAPIClientを使用してテストする() async throws {
        let fortuneAPIClient = FortuneFetcher()
        let day = try Day(year: 2000, month: 1, day: 1)

        let fortuneAPIResponse = try await fortuneAPIClient.fetchFortune(
            name: "XXXXX",
            birthday: day,
            bloodType: .a
        )
    }
}
