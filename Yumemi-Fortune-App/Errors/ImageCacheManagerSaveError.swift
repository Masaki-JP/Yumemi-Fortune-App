import Foundation

enum ImageCacheManagerSaveError: Error {
    case cacheDirectoryNotFound
    case multipleCacheDirectoriesFound
    case saveFailture
}
