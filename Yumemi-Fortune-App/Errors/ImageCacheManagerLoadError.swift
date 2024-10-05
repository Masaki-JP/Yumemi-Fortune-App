import Foundation

enum ImageCacheManagerLoadError: Error {
    case cacheDirectoryNotFound
    case multipleCacheDirectoriesFound
    case noData
    case invalidData
}
