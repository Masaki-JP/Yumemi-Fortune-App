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
        if case .success = getPrefectureImageResult { print("すでにUIImageの取得に成功しているためリターンします。"); return }
        getPrefectureImageResult = nil

        print("キャッシュの検索を開始します。")
        do throws(ImageCacheManagerLoadError) {
            let prefectureImageData = try await ImageCacheManager.shared.load(with: fortuneResult.logoURL)

            if let uiImage = UIImage(data: prefectureImageData) {
                getPrefectureImageResult = .success(uiImage)
                print("キャッシュが見つかりました。値をセット後、処理を終了します。"); return
            } else {
                print("キャッシュは見つかりましたが、UIImageの生成に失敗しました。処理を継続します。")
            }
        } catch {
            switch error {
            case .noData:
                print("指定されたURLの画像キャッシュは見つかりませんでした。処理を継続します。")
            case .cacheDirectoryNotFound, .multipleCacheDirectoriesFound, .invalidData:
                print("予期せぬエラーが発生しました。処理を継続します。")
            }
        }

        print("画像データの取得します。")
        let data: Data
        do {
            (data, _) = try await URLSession.shared.data(from: fortuneResult.logoURL)
            print("画像データの取得に成功しました。処理を継続します。")
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

            getPrefectureImageResult = .failure(message == nil ? .init() : .init(message!))
            print("画像データの取得に失敗しました。処理を終了します。"); return
        } catch {
            getPrefectureImageResult = .failure(.init());
            print("画像データの取得に失敗しました。処理を終了します。"); return
        }

        print("画像データの保存します。")
        do throws(ImageCacheManagerSaveError) {
            try await ImageCacheManager.shared.save(data: data, webResourceURL: fortuneResult.logoURL)
            print("画像データの保存に成功しました。")
        } catch {
            switch error {
            case .saveFailture:
                print("画像データのセーブに失敗しました。")
            case .cacheDirectoryNotFound, .multipleCacheDirectoriesFound:
                print("予期せぬエラーが発生しました。")
            }
        }

        print("取得した画像データからUIImageを生成します。")
        guard let uiImage = UIImage(data: data) else {
            print("UIImageの生成に失敗しました。")
            getPrefectureImageResult = .failure(.init()); return
        }
        print("UIImageの生成に成功しました。値をセットします。")
        getPrefectureImageResult = .success(uiImage)
    }
}
