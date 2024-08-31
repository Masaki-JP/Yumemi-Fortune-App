import Foundation

extension FortuneAPIResponse {
    /// {"name":"Naruto","birthday":{"month":10,"day":10,"year":2000},"today":{"month":10,"year":2020,"day":10},"blood_type":"a"}
    ///
    /// これを送って返ってきたやつ
    static var sample: Self {
        try! .init(
            name: "静岡県",
            capital: "静岡市",
            citizenDay: .init(month: 8, day: 21),
            hasCoastLine: true,
            logoURL: URL(string: "https://japan-map.com/wp-content/uploads/shizuoka.png")!,
            brief: "静岡県（しずおかけん）は、日本の中部地方に位置する県。県庁所在地は静岡市。\n※出典: フリー百科事典『ウィキペディア（Wikipedia）』"
        )
    }
}
