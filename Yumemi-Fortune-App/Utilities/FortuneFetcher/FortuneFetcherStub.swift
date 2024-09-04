import Foundation

struct FortuneFetcherStub: FortuneFetcherProtocol {
    var fetchResult: Result<FortuneAPIResponse, FortuneFetcher.Error>

    init(_ fetchResult: Result<FortuneAPIResponse, FortuneFetcher.Error>) {
        self.fetchResult = fetchResult
    }

    func fetchFortune(name: String, birthday: Day, bloodType: BloodType) async throws -> FortuneAPIResponse {
        switch fetchResult {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }
}
