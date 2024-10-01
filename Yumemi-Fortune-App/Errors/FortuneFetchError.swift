import Foundation

enum FortuneFetchError: Error {
    case noName
    case tooLongName
    case invalidBirthday
    case urlInitializeFailure
    case encodeFailure
    case possibleNetworkError
    case unexpectedResponse
    case decodeFailure
    case unexpectedError(_ messege: String)
}
