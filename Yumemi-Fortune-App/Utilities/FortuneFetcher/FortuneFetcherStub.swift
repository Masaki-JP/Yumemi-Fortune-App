import Foundation

struct FortuneFetcherStub: FortuneFetcherProtocol {
    var result: Result<FortuneAPIResponse, FortuneFetcher.Error>

    init(_ result: Result<FortuneAPIResponse, FortuneFetcher.Error>) {
        self.result = result
    }

    func fetch(name: String, birthday: Day, bloodType: BloodType) async throws -> FortuneAPIResponse {
        switch result {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }
}
