import XCTest
@testable import Yumemi_Fortune_App

final class FortuneFetcherTests: XCTestCase {

    var fortuneFetcher: FortuneFetcher!

    override func setUpWithError() throws {
        fortuneFetcher = .init(.mock(for: .fortuneAPI))
    }

    func test_正常系_有効な引数が与えられた時に問題なく動作すること() async {
        let fortuneResult = try? await fortuneFetcher.fetch(
            name: "Sasuke",
            birthday: .sample,
            bloodType: .a)

        XCTAssertNotNil(fortuneResult, "有効な引数が与えられたのにも関わらずFortuneResultの取得に失敗している。")
    }

    func test_異常系_引数nameに空文字が与えられた時に適切なエラーを投げること() async {
        do {
            let _ = try await fortuneFetcher.fetch(
                name: "", // Empty String
                birthday: .sample,
                bloodType: .a)

            XCTFail("エラーが投げられていない。")
        } catch {
            guard case .noName = error else {
                XCTFail("適切なエラーが投げられていない。"); return;
            }
        }
    }

    func test_異常系_引数nameに100文字以上の文字列が与えられた時に適切なエラーを投げること() async {
        let name: String = .init(repeating: "A", count: 101)

        do {
            let _ = try await fortuneFetcher.fetch(
                name: name,
                birthday: .sample,
                bloodType: .a)

            XCTFail("エラーが投げられていない。")
        } catch {
            guard case .tooLongName = error else {
                XCTFail("適切なエラーが投げられていない。"); return;
            }
        }
    }

    func test_フレイキーテスト_実際にFortuneAPIClientを使用してテストする() async throws {
        let fortuneFetcher = FortuneFetcher()
        let day = try Day(year: 2000, month: 1, day: 1)

        let _ = try await fortuneFetcher.fetch(
            name: "XXXXX",
            birthday: day,
            bloodType: .a
        )
    }
}
