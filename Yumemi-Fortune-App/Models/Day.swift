import Foundation

struct Day: Codable, Comparable {

    let year, month, day: Int

    enum Error: Swift.Error {
        case invalidDay
        case invalidDecodedDay
        case unexpectedError(_ msg: String)
    }

    static func < (lhs: Day, rhs: Day) -> Bool {
        if lhs.year != rhs.year {
            lhs.year < rhs.year
        } else if lhs.month != rhs.month {
            lhs.month < rhs.month
        } else {
            lhs.day < rhs.day
        }
    }

    init(year: Int, month: Int, day: Int) throws {
        self.year = year
        self.month = month
        self.day = day
        try validate(self)
    }

    init(_ date: Date) {
        let year = Self.calendar.component(.year, from: date)
        let month = Self.calendar.component(.month, from: date)
        let day = Self.calendar.component(.day, from: date)

        self.year = year
        self.month = month
        self.day = day
        try! validate(self)
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.year = try container.decode(Int.self, forKey: .year)
        self.month = try container.decode(Int.self, forKey: .month)
        self.day = try container.decode(Int.self, forKey: .day)

        do {
            try validate(self)
        } catch {
            throw Self.Error.invalidDecodedDay
        }
    }

    static let calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .init(identifier: "Asia/Tokyo")!
        return calendar
    }()

    static var today: Self {
        let now = Date.now
        let year = calendar.component(.year, from: now)
        let month = calendar.component(.month, from: now)
        let day = calendar.component(.day, from: now)

        return try! Day(year: year, month: month, day: day)
    }

    private func validate(_ day: Day) throws {
        let dateComponents = DateComponents(calendar: Self.calendar, timeZone: Self.calendar.timeZone, year: day.year, month: day.month, day: day.day)

        guard dateComponents.isValidDate else {
            throw Self.Error.invalidDay
        }

        guard let date = dateComponents.date else {
            let msg = "\(#function): 有効なDateComponentからDateを生成できませんでした。"
            throw Self.Error.unexpectedError(msg)
        }

        guard date < .now else {
            throw Self.Error.invalidDay
        }
    }
}
