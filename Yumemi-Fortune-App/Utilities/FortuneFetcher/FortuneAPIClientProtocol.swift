import Foundation

protocol FortuneAPIClientProtocol {
    func fetchFortune(name: String, birthday: Day, bloodType: BloodType) async throws -> FortuneAPIResponse
}
