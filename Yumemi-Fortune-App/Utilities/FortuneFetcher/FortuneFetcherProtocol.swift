import Foundation

protocol FortuneFetcherProtocol {
    func fetch(name: String, birthday: Day, bloodType: BloodType) async throws -> FortuneAPIResponse
}
