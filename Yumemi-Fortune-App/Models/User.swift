import SwiftData

@Model
final class User {
    private(set) var name: String
    private(set) var birthday: Day
    private(set) var bloodType: BloodType
    private(set) var fortuneResultList: [Day: FortuneResult]

    var todayFortune: FortuneResult? {
        fortuneResultList.first { $0.key == .today }?.value
    }

    init(name: String, birthday: Day, bloodType: BloodType, fortuneResultList: [Day: FortuneResult] = .init()) {
        self.name = name
        self.birthday = birthday
        self.bloodType = bloodType
        self.fortuneResultList = fortuneResultList
    }

    func updateName(to name: String) {
        self.name = name
    }

    func updateBirthday(to birthday: Day) {
        self.birthday = birthday
    }

    func updateBloodType(to bloodType: BloodType) {
        self.bloodType = bloodType
    }

    func addFortuneResult(_ fortuneResult: FortuneResult) {
        guard fortuneResultList[.today] == nil else { return }
        fortuneResultList[.today] = fortuneResult
    }
}
