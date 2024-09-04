import Foundation

protocol FortuneFetcherProtocol {
    func fetchFortune(name: String, birthday: Day, bloodType: BloodType) async throws -> FortuneAPIResponse
}
