import Foundation

@MainActor @Observable
final class GetFortuneViewModel {
    let user: User

    init(user: User) {
        self.user = user
    }

    func didTapGetFortuneButton() {
        guard user.fortuneResultList.contains(where: { $0.key == .today }) == false else {
            print("すでに占い済み"); return
        }

        Task {
            let fortuneFetcher = FortuneFetcher(.mock(for: .fortuneAPI))

            guard let fortuneResult = try? await fortuneFetcher.fetch(
                name: user.name,
                birthday: user.birthday,
                bloodType: user.bloodType
            ) else {
                print("占い結果の取得に失敗。"); return
            }

            user.addFortuneResult(fortuneResult)
        }
    }
}
