import SwiftUI

/// ``FortuneResultView``で使用するViewModel。
///
/// 何か問題が生じた際はアラートを使わず、``getPrefectureImageResult``を通してユーザーに伝える。
///
@MainActor @Observable
final class FortuneResultViewModel {

    /// ``FortuneResultView``で詳細を表示する``FortuneResult``。
    ///
    let fortuneResult: FortuneResult

    /// ``FortuneResultView``に都道府県の画像、もしくはエラーを伝えるためのプロパティ。
    ///
    /// >note: 画像の取得中は`nil`としている。
    ///
    private(set) var getPrefectureImageResult: Result<UIImage, GetPrefectureImageError>? = nil

    /// `Result<Success, Failure>`を使用するために作成したオブジェクト。
    ///
    struct GetPrefectureImageError: Error {
        let message: String

        init(_ message: String = "画像データの取得に失敗しました。") {
            self.message = message
        }
    }

    init(_ fortuneResult: FortuneResult) {
        self.fortuneResult = fortuneResult
    }

    /// ``FortuneResultView``が表示された時に実行される処理。
    ///
    /// `task`モディファイア内で呼ばれることを想定している。
    ///
    func onAppearAction() async {
        /// すでに成功している場合は早期リターンする。
        if case .success = getPrefectureImageResult { return }
        /// 失敗していた場合を考慮し、`nil`を代入する。`.failure`のままだと`ProgressView`が表示されない。
        getPrefectureImageResult = nil

        /// キャッシュから画像データの取得し`UIImage`を生成できた場合、`getPrefectureImageResult`に成功として代入する。
        if let prefectureImageData = await getPrefectureImageDataFromCache(),
           let uiImage = UIImage(data: prefectureImageData) {
            getPrefectureImageResult = .success(uiImage); return
        }

        /// 通信を用いて画像データを取得する。失敗した場合は、エラーを`getPrefectureImageResult`に失敗として代入する。
        let prefectureImageData: Data
        switch await fetchPrefectureImageData() {
        case .success(let data):
            prefectureImageData = data
        case .failure(let error):
            getPrefectureImageResult = .failure(error); return
        }

        /// 取得した画像データから`UIImage`を生成する。失敗した場合は、`getPrefectureImageResult`に`GetPrefectureImageError`を失敗として代入する。
        guard let uiImage = UIImage(data: prefectureImageData) else {
            getPrefectureImageResult = .failure(.init("予期せぬエラーが発生しました。")); return
        }

        /// 生成した`UIImage`を`getPrefectureImageResult`に成功としてに代入する。
        getPrefectureImageResult = .success(uiImage)

        /// 画像が保存されているURL（Webリソース）をキーとして、取得したデータを保存する。
        saveToCache(data: prefectureImageData, webResourceURL: fortuneResult.logoURL)
    }
}

// MARK: - The following methods are private.

private extension FortuneResultViewModel {

    /// /// キャッシュに画像データを保存する。
    func saveToCache(data: Data, webResourceURL: URL)  {
        Task.detached {
            try? await ImageCacheManager.shared.save(data: data, webResourceURL: webResourceURL)
        }
    }

    /// キャッシュから画像データを取得する。
    func getPrefectureImageDataFromCache() async -> Data? {
        do throws(ImageCacheManagerLoadError) {
            return try await ImageCacheManager.shared.load(with: fortuneResult.logoURL)
        } catch {
            switch error {
            case .noData: return nil
            case .cacheDirectoryNotFound, .multipleCacheDirectoriesFound, .invalidData: return nil
            }
        }
    }

    /// 通信を用いて画像データを取得する。
    func fetchPrefectureImageData() async -> Result<Data, GetPrefectureImageError> {
        do {
            let (data, _) = try await URLSession.shared.data(from: fortuneResult.logoURL)
            return .success(data)
        } catch let error as URLError {
            let message: String? = switch error.code {
            case .networkConnectionLost: "ネットワーク接続が失われました。"
            case .notConnectedToInternet: "ネットワークに接続されていません。"
            case .timedOut: "画像の取得中タイムアウトが発生しました。"
            case .cannotFindHost: "ホストが見つかりませんでした。"
            case .cannotConnectToHost: "ホストに接続できませんでした。"
            case .dataNotAllowed: "データ通信は許可されていません。"
            case .cancelled: "画像の取得がキャンセルされました。"
            default: nil
            }

            return .failure(message == nil ? .init() : .init(message!)) // Force-Unwrap
        } catch {
            return .failure(.init())
        }
    }
}
