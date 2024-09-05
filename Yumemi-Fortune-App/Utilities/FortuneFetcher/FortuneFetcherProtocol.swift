import Foundation

/// ``FortuneResult``の取得を行うオブジェクトのインターフェース。
///
protocol FortuneFetcherProtocol {

    /// ``FortuneResult``を取得するメソッド。
    /// - Parameters:
    ///   - name: ユーザーの名前を指定する。
    ///   - birthday: ユーザーの誕生日を指定する。
    ///   - bloodType: ユーザーの血液型を指定する。
    /// - Returns: 取得した``FortuneResult``を返す。
    ///
    func fetch(name: String, birthday: Day, bloodType: BloodType) async throws -> FortuneResult
}
