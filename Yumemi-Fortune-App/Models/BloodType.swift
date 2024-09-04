import Foundation

enum BloodType: String, Codable, CaseIterable {
    case a = "A", b = "B", ab = "AB", o = "O"

    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue.lowercased())
    }
}
