import Foundation

struct FortuneFetcherStub: FortuneFetcherProtocol {
    var result: Result<FortuneResult, FortuneFetcher.FetchError>

    init(_ result: Result<FortuneResult, FortuneFetcher.FetchError>) {
        self.result = result
    }

    func fetch(name: String, birthday: Day, bloodType: BloodType) async throws -> FortuneResult {
        switch result {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }
}
