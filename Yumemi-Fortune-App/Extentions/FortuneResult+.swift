import Foundation

extension FortuneResult {

    /// ``FortuneResult``のサンプル。
    ///
    /// - 都道府県：静岡県
    /// - 首都：静岡市
    /// - 県民日：8月21日
    /// - 海岸の有無：有り
    /// - ロゴURL：[https://japan-map.com/wp-content/uploads/shizuoka.png](https://japan-map.com/wp-content/uploads/shizuoka.png)
    ///
    static var sample1: Self {
        .init(
            compatiblePrefecture: "静岡県",
            capital: "静岡市",
            citizenDay: .init(month: 8, day: 21),
            hasCoastLine: true,
            logoURL: URL(string: "https://japan-map.com/wp-content/uploads/shizuoka.png")!,
            brief: "静岡県（しずおかけん）は、日本の中部地方に位置する県。県庁所在地は静岡市。\n※出典: フリー百科事典『ウィキペディア（Wikipedia）』"
        )
    }

    /// ``FortuneResult``のサンプル。
    ///
    /// - 都道府県：静岡県
    /// - 首都：静岡市
    /// - 県民日：8月21日
    /// - 海岸の有無：有り
    /// - ロゴURL：[https://japan-map.com/wp-content/uploads/shizuoka.png](https://japan-map.com/wp-content/uploads/shizuoka.png)
    ///
    static var sample2: Self {
        .init(
            compatiblePrefecture: "兵庫県",
            capital: "神戸市",
            citizenDay: nil,
            hasCoastLine: true,
            logoURL: URL(string: "https://japan-map.com/wp-content/uploads/hyogo.png")!,
            brief: "兵庫県（ひょうごけん）は、日本の近畿地方の西端に位置する県。県庁所在地は神戸市。\n※出典: フリー百科事典『ウィキペディア（Wikipedia）』"
        )
    }

    /// ``FortuneResult``のサンプル。
    ///
    /// - 都道府県：千葉県
    /// - 首都：千葉市
    /// - 県民日：6月15日
    /// - 海岸の有無：有り
    /// - ロゴURL：[https://japan-map.com/wp-content/uploads/chiba.png](https://japan-map.com/wp-content/uploads/chiba.png)
    ///
    static var sample3: Self {
        .init(
            compatiblePrefecture: "千葉県",
            capital: "千葉市",
            citizenDay: .init(month: 6, day: 15),
            hasCoastLine: true,
            logoURL: URL(string: "https://japan-map.com/wp-content/uploads/chiba.png")!,
            brief: "千葉県（ちばけん）は、日本の関東地方に位置する県。県庁所在地は千葉市。\n首都圏を構成し、都道府県人口・人口密度は第6位、県の財政力指数は全国第5位、面積は第28位の規模である。\n※出典: フリー百科事典『ウィキペディア（Wikipedia）』"
        )
    }
}
