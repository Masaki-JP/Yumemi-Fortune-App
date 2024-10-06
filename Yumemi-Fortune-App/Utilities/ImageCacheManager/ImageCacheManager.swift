import Foundation
import CryptoKit

/// 画像データのキャッシュの管理を担うオブジェクト。
///  
/// 画像が保存されているURL（Webリソース）をキーとして、キャッシュ管理を行う。
///
/// >important: シングルトンインスタンスを通して使用する。
///
final actor ImageCacheManager {

    /// ``ImageCacheManager``の共有インスタンス。
    ///
    static let shared = ImageCacheManager()

    /// 外部からインスタンスを生成されないようにアクセスレベルをプライベートに設定している。
    ///
    private init() {}

    /// 画像が保存されているURL（Webリソース）をキーとして、指定されたデータをセーブする。
    ///
    /// - Parameters:
    ///   - data: 保存するデータを指定する。
    ///   - webResourceURL: 画像が保存されているURL（Webリソース）を指定する。
    ///
    func save(data: Data, webResourceURL: URL) throws(ImageCacheManagerSaveError) {
        let cacheDirectoryURL: URL

        do throws(PrivateError) {
            cacheDirectoryURL =  try getCacheDirectoryURL()
        } catch {
            throw error.asImageCacheManagerSaveError
        }

        let fileURL = getFileURL(for: webResourceURL, in: cacheDirectoryURL)

        do {
            try data.write(to: fileURL)
        } catch {
            throw .saveFailture
        }
    }
    
    /// 画像が保存されているURL（Webリソース）をキーとして、データをロードする。
    ///
    /// - Parameter webResourceURL: 画像が保存されているURL（Webリソース）を指定する。
    /// - Returns: ロードした画像データを返す。
    ///
    func load(with webResourceURL: URL) throws(ImageCacheManagerLoadError) -> Data {
        let cacheDirectoryURL: URL

        do throws(PrivateError) {
            cacheDirectoryURL =  try getCacheDirectoryURL()
        } catch {
            throw error.asImageCacheManagerLoadError
        }

        let fileURL = getFileURL(for: webResourceURL, in: cacheDirectoryURL)

        do {
            return try Data.init(contentsOf: fileURL)
        } catch {
            let nsError = error as NSError
            throw nsError.code == 260 ? .noData : .invalidData
        }
    }
}

private extension ImageCacheManager {

    enum PrivateError: Error {
        case cacheDirectoryNotFound
        case multipleCacheDirectoriesFound

        var asImageCacheManagerSaveError: ImageCacheManagerSaveError  {
            switch self {
            case .cacheDirectoryNotFound: .cacheDirectoryNotFound
            case .multipleCacheDirectoriesFound: .multipleCacheDirectoriesFound
            }
        }

        var asImageCacheManagerLoadError: ImageCacheManagerLoadError  {
            switch self {
            case .cacheDirectoryNotFound: .cacheDirectoryNotFound
            case .multipleCacheDirectoriesFound: .multipleCacheDirectoriesFound
            }
        }
    }

    func getFileURL(for webResourceURL: URL, in directoryURL: URL) -> URL {
        let hashedFileName = SHA256.hash(data: Data(webResourceURL.absoluteString.utf8))
            .map { String(format: "%02x", $0)  }
            .joined()

        return directoryURL.appending(path: hashedFileName, directoryHint: .notDirectory)
    }

    func getCacheDirectoryURL() throws(PrivateError) -> URL {
        let cacheDirectories = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)

        guard cacheDirectories.count < 2 else {
            throw .multipleCacheDirectoriesFound
        }

        guard let cacheDirectory = cacheDirectories.first else {
            throw .cacheDirectoryNotFound
        }

        return cacheDirectory
    }
}
