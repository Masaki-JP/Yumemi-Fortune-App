import Foundation

struct FortuneAPIResponse: Codable, Hashable {
    private(set) var name: String
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
    ) throws {
        self.name = name
        self.capital = capital
        self.citizenDay = citizenDay
        self.hasCoastLine = hasCoastLine
        self.logoURL = logoURL
        self.brief = brief

        try validateName(self.name)
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.capital = try container.decode(String.self, forKey: .capital)
        self.brief = try container.decode(String.self, forKey: .brief)
        self.citizenDay = try container.decodeIfPresent(FortuneAPIResponse.CitizenDay.self, forKey: .citizenDay)
        self.hasCoastLine = try container.decode(Bool.self, forKey: .hasCoastLine)
        self.logoURL = try container.decode(URL.self, forKey: .logoURL)

        try validateName(self.name)
    }

    enum Error: Swift.Error {
        case noName, tooLongName
    }

    mutating func updateName(to newName: String) throws {
        try validateName(newName)
        self.name = newName
    }

    private func validateName(_ name: String) throws {
        guard name.isEmpty == false else { throw Self.Error.noName }
        guard name.count < 100 else { throw Self.Error.tooLongName }
    }
}
