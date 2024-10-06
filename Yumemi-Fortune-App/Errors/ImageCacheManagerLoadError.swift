import Foundation

/// ``ImageCacheManager/load(with:)``メソッドの実行時に発生することのあるエラー。
///
enum ImageCacheManagerLoadError: Error {
    case cacheDirectoryNotFound
    case multipleCacheDirectoriesFound
    case noData
    case invalidData
}
