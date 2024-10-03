import Foundation

/// ``FortuneFetcherProtocol/fetch(name:birthday:bloodType:)``メソッドの実行時に発生することのあるエラー。
///
enum FortuneFetchError: Error {
    case networkConnectionLost
    case notConnectedToInternet
    case requestTimeOut
    case cannotFindHost
    case cannnotConnectToHost
    case dataNotAllowed
    case requestCancelled
    case anyNetworkError
    case urlInitializeFailure
    case encodeFailure
    case unexpectedResponse
    case decodeFailure
    case unexpectedError(_ messege: String)
}
