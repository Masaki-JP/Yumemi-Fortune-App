import Foundation

/// 血液型を表すケース群。
///
/// ローバリューとして``Foundation/String``が設定されており、各ケースの`rawValue`はそのケースの大文字となる。
///
/// >note:
/// エンコード時は小文字にエンコードされる。
///
enum BloodType: String, Codable, CaseIterable {
    case a = "A", b = "B", ab = "AB", o = "O"

    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue.lowercased())
    }
}
