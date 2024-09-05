import Foundation

/// ``FortuneFetcher``のスタブ。
///
struct FortuneFetcherStub: FortuneFetcherProtocol {

    /// ``fetch(name:birthday:bloodType:)``の実行時に返される``FortuneResult``、もしくは失敗時に投げられる``FortuneFetcher/FetchError``。
    ///
    var result: Result<FortuneResult, FortuneFetcher.FetchError>
    
    /// ``FortuneFetcherStub``のイニシャライザ。
    /// - Parameter result: ``fetch(name:birthday:bloodType:)``の実行時に返される``FortuneResult``、もしくは失敗時に投げられる``FortuneFetcher/FetchError``を指定する。
    ///
    init(_ result: Result<FortuneResult, FortuneFetcher.FetchError>) {
        self.result = result
    }
    
    /// ``FortuneResult``を取得するメソッド。
    ///
    /// ``FortuneFetcherStub/result``が`.success(:)`であれば、設定されている``FortuneResult``を返し、`.failure(:)`であれば、設定されている``FortuneFetcher/FetchError``を投げる。
    ///
    /// - Parameters:
    ///   - name: ユーザーの名前を指定する。あくまで引数として受け取るのみで、結果に影響を及ぼさない。
    ///   - birthday: ユーザーの誕生日を指定する。あくまで引数として受け取るのみで、結果に影響を及ぼさない。
    ///   - bloodType: ユーザーの血液型を指定する。あくまで引数として受け取るのみで、結果に影響を及ぼさない。
    /// - Returns: 設定されている``FortuneResult``を返す。
    ///
    func fetch(name: String, birthday: Day, bloodType: BloodType) async throws -> FortuneResult {
        switch result {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }
}
