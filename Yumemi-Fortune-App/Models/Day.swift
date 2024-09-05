import Foundation

/// 日付を表すオプジェクト。
struct Day: Codable, Comparable {

    let year, month, day: Int

    /// 初期化時に発生することのあるエラー。
    ///
    enum initializeError: Swift.Error {
        case invalidDay
        case invalidDecodedDay
        case unexpectedError(_ msg: String)
    }
    
    /// ``Day``のイニシャライザ。
    ///
    /// 2020年20月20日など存在しない日付は作成することができない。
    /// このイニシャライザが投げる可能性のあるエラーは現状``Day/initializeError``のみである。
    ///
    init(year: Int, month: Int, day: Int) throws {
        self.year = year
        self.month = month
        self.day = day
        try self.validate()
    }
    
    /// ``Day``のイニシャライザ。
    ///
    /// ``Foundation/Date``から``Day``を生成する。
    /// このイニシャライザが投げる可能性のあるエラーは現状``Day/initializeError``のみである。
    ///
    /// - Parameter date: ``Day``に変換する``Foundation/Date``。
    ///
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
            throw Self.initializeError.invalidDecodedDay
        }
    }

    static let calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = .init(identifier: "Asia/Tokyo")!
        return calendar
    }()
    
    /// アクセス時の``Day``を返す静的計算型プロパティ。
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
