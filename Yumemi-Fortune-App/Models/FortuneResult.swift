import Foundation

struct FortuneResult: Codable, Hashable {
    let compatiblePrefectureName: String
    let capital: String
    let citizenDay: CitizenDay?
    let hasCoastLine: Bool
    let logoURL: URL
    let brief: String

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
