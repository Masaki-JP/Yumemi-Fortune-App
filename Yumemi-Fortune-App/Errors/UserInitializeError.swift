import Foundation

/// ``User/init(name:birthday:bloodType:fortuneResultList:)``の実行時に発生することのあるエラー。
///
enum UserInitializeError: Error {
    case noName, tooLongName
}
