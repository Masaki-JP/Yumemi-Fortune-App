import Foundation

struct Day: Codable, Comparable {

    let year, month, day: Int

    enum Error: Swift.Error {
        case invalidDay
        case invalidDecodedDay
        case unexpectedError(_ msg: String)
    }

    init(year: Int, month: Int, day: Int) throws {
        self.year = year
        self.month = month
        self.day = day
        try self.validate()
    }

    init(_ date: Date) {
        let year = Self.calendar.component(.year, from: date)
        let month = Self.calendar.component(.month, from: date)
        let day = Self.calendar.component(.day, from: date)

        self.year = year
        self.month = month
        self.day = day
        try! self.validate()
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.year = try container.decode(Int.self, forKey: .year)
        self.month = try container.decode(Int.self, forKey: .month)
        self.day = try container.decode(Int.self, forKey: .day)

        do {
            try self.validate()
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

    static func < (lhs: Day, rhs: Day) -> Bool {
        if lhs.year != rhs.year {
            lhs.year < rhs.year
        } else if lhs.month != rhs.month {
            lhs.month < rhs.month
        } else {
            lhs.day < rhs.day
        }
    }
}
