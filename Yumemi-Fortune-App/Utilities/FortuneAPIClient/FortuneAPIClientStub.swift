import Foundation

struct FortuneAPIClientStub: FortuneAPIClientProtocol {
    var fetchResult: Result<FortuneAPIResponse, FortuneAPIClient.Error>

    init(_ fetchResult: Result<FortuneAPIResponse, FortuneAPIClient.Error>) {
        self.fetchResult = fetchResult
    }

    func fetchFortune(name: String, birthday: Day, bloodType: BloodType) async throws -> FortuneAPIResponse {
        switch fetchResult {
        case .success(let value): return value
        case .failure(let error): throw error
        }
    }
}
