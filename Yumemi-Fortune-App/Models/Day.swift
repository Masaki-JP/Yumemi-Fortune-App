import Foundation

/// 日付を表すオプジェクト。
struct Day: Codable, Comparable, Hashable {

    let year, month, day: Int

    /// 日本語で表現した``Day``を返す。
    ///
    var japaneseFormatted: String {
        "\(year)年\(month)月\(day)日"
    }

    /// 自身を`Date`に変換したものを返す。変換に失敗した場合は`nil`を返す。
    ///
    var asDate: Date? {
        var calendar = Calendar(identifier: .gregorian)
        guard let timeZone = TimeZone(identifier: "Asia/Tokyo") else { return nil }
        calendar.timeZone = timeZone

        return calendar.date(from: .init(year: year, month: month, day: day))
    }

    /// 初期化時に発生することのあるエラー。
    ///
    enum InitializeError: Swift.Error {
        case invalidDay
        case invalidDecodedDay
        case unexpectedError(_ msg: String)
    }

    /// ``Day``のイニシャライザ。
    ///
    /// 2020年20月20日など存在しない日付は作成することができない。
    /// このイニシャライザが投げる可能性のあるエラーは現状``Day/InitializeError``のみ。
    ///
    init(year: Int, month: Int, day: Int) throws {
        self.year = year
        self.month = month
        self.day = day
        try self.validate()
    }

    /// ``Day``のイニシャライザ。
    ///
    /// `Date`から``Day``を生成する。
    ///
    /// - Parameter date: ``Day``に変換する`Date`。
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
            throw Self.InitializeError.invalidDecodedDay
        }
    }

    private static let calendar = {
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

    private func validate() throws {
        let dateComponents = DateComponents(calendar: Self.calendar, timeZone: Self.calendar.timeZone, year: self.year, month: self.month, day: self.day)

        guard dateComponents.isValidDate else {
            throw Self.InitializeError.invalidDay
        }

        guard let date = dateComponents.date else {
            let msg = "\(#function): 有効なDateComponentからDateを生成できませんでした。"
            throw Self.InitializeError.unexpectedError(msg)
        }

        guard date < .now else {
            throw Self.InitializeError.invalidDay
        }
    }
}
