import Foundation

/// ``ImageCacheManager/save(data:webResourceURL:)``メソッドの実行時に発生することのあるエラー。
///
enum ImageCacheManagerSaveError: Error {
    case cacheDirectoryNotFound
    case multipleCacheDirectoriesFound
    case saveFailture
}
