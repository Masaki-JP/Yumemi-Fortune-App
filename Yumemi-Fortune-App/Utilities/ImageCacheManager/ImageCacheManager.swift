import Foundation
import CryptoKit

struct ImageCacheManager {

    func save(data: Data, url: URL) throws(ImageCacheManagerSaveError) {
        let cacheDirectoryURL: URL

        do throws(PrivateError) {
            cacheDirectoryURL =  try getCacheDirectoryURL()
        } catch {
            throw error.asImageCacheManagerSaveError
        }

        let fileURL = getFileURL(for: url, in: cacheDirectoryURL)

        do {
            try data.write(to: fileURL)
        } catch {
            throw .saveFailture
        }
    }

    func load(with url: URL) throws(ImageCacheManagerLoadError) -> Data {
        let cacheDirectoryURL: URL

        do throws(PrivateError) {
            cacheDirectoryURL =  try getCacheDirectoryURL()
        } catch {
            throw error.asImageCacheManagerLoadError
        }

        let fileURL = getFileURL(for: url, in: cacheDirectoryURL)

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

    func getFileURL(for url: URL, in directoryURL: URL) -> URL {
        let hashedFileName = SHA256.hash(data: Data(url.absoluteString.utf8))
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
