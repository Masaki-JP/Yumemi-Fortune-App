import SwiftUI

@MainActor @Observable
final class FortuneResultViewModel {

    let fortuneResult: FortuneResult
    private(set) var getPrefectureImageResult: Result<UIImage, GetPrefectureImageError>? = nil

    struct GetPrefectureImageError: Error {
        let message: String

        init(_ message: String = "画像データの取得に失敗しました。") {
            self.message = message
        }
    }

    init(_ fortuneResult: FortuneResult) {
        self.fortuneResult = fortuneResult
    }

    func onAppearAction() async {
        if case .success = getPrefectureImageResult { return }
        getPrefectureImageResult = nil

        if let prefectureImageData = await getPrefectureImageData(),
           let uiImage = UIImage(data: prefectureImageData) {
            getPrefectureImageResult = .success(uiImage); return
        }

        let prefectureImageData: Data
        switch await fetchPrefectureImageData() {
        case .success(let data):
            prefectureImageData = data
        case .failure(let error):
            getPrefectureImageResult = .failure(error); return
        }

        guard let uiImage = UIImage(data: prefectureImageData) else {
            getPrefectureImageResult = .failure(.init("予期せぬエラーが発生しました。")); return
        }

        getPrefectureImageResult = .success(uiImage)

        try? await ImageCacheManager.shared.save(data: prefectureImageData, webResourceURL: fortuneResult.logoURL)
    }
}

extension FortuneResultViewModel {

    private func getPrefectureImageData() async -> Data? {
        do throws(ImageCacheManagerLoadError) {
            return try await ImageCacheManager.shared.load(with: fortuneResult.logoURL)
        } catch {
            switch error {
            case .noData: return nil
            case .cacheDirectoryNotFound, .multipleCacheDirectoriesFound, .invalidData: return nil
            }
        }
    }

    private func fetchPrefectureImageData() async -> Result<Data, GetPrefectureImageError> {
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

            return .failure(message == nil ? .init() : .init(message!))
        } catch {
            return .failure(.init())
        }
    }
}
