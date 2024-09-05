import Foundation

/// 占い結果を表すオブジェクト。
struct FortuneResult: Codable, Hashable {
    /// 相性のいい都道府県を表す。
    let compatiblePrefectureName: String
    /// 相性のいい都道府県の首都を表す。
    let capital: String
    /// 相性のいい都道府県の県民日を表す。県民日が制定されていない都道府県の場合は`nil`になる。
    let citizenDay: CitizenDay?
    /// 海岸の有無を表す。
    let hasCoastLine: Bool
    /// 相性のいい都道府県の画像のリンク。
    let logoURL: URL
    /// 相性のいい都道府県の概要。
    let brief: String
    
    /// 県民日を表すオブジェクト。
    struct CitizenDay: Codable, Hashable {
        let month, day: Int
    }

    enum CodingKeys: String, CodingKey {
        case compatiblePrefectureName = "name"
        case citizenDay = "citizen_day"
        case hasCoastLine = "has_coast_line"
        case logoURL = "logo_url"
        case capital, brief
    }

    init(
        name: String,
        capital: String,
        citizenDay: CitizenDay?,
        hasCoastLine: Bool,
        logoURL: URL,
        brief: String
    ) {
        self.compatiblePrefectureName = name
        self.capital = capital
        self.citizenDay = citizenDay
        self.hasCoastLine = hasCoastLine
        self.logoURL = logoURL
        self.brief = brief
    }
}
