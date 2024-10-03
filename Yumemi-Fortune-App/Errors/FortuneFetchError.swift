import Foundation

/// ``FortuneFetcherProtocol/fetch(name:birthday:bloodType:)``メソッドの実行時に発生することのあるエラー。
///
enum FortuneFetchError: Error {
    case urlInitializeFailure
    case encodeFailure
    case possibleNetworkError
    case unexpectedResponse
    case decodeFailure
    case unexpectedError(_ messege: String)
}
