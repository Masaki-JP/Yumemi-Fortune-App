import Foundation

struct FortuneAPIResponse: Codable, Hashable {
    let name: String
    let capital: String
    let citizenDay: CitizenDay?
    let hasCoastLine: Bool
    let logoURL: URL
    let brief: String

    struct CitizenDay: Codable, Hashable {
        let month, day: Int
    }

    enum CodingKeys: String, CodingKey {
        case name, capital, brief
        case citizenDay = "citizen_day"
        case hasCoastLine = "has_coast_line"
        case logoURL = "logo_url"
    }

    init(
        name: String,
        capital: String,
        citizenDay: CitizenDay?,
        hasCoastLine: Bool,
        logoURL: URL,
        brief: String
    ) {
        self.name = name
        self.capital = capital
        self.citizenDay = citizenDay
        self.hasCoastLine = hasCoastLine
        self.logoURL = logoURL
        self.brief = brief
    }
}
