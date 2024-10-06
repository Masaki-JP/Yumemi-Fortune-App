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

        /// URLErrorのハンドリング
        print("画像データの取得します。")
        guard let (data, _) = try? await URLSession.shared.data(from: fortuneResult.logoURL) else {
            print("画像データの取得に失敗しました。処理を終了します。")
            getPrefectureImageResult = .failure(.init())
            return
        }
        print("画像データの取得に成功しました。処理を継続します。")

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
