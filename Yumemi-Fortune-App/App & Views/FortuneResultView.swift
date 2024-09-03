import SwiftUI

struct FortuneResultView: View {
    private let fortuneAPIResponse: FortuneAPIResponse

    init(_ fortuneAPIResponse: FortuneAPIResponse) {
        self.fortuneAPIResponse = fortuneAPIResponse
    }

    var body: some View {
        List {
            HStack(spacing: 0) {
                Text("相性のいい都道府県：")
                Spacer()
                Text(fortuneAPIResponse.name)
            }
            HStack(spacing: 0) {
                Text("首都：")
                Spacer()
                Text(fortuneAPIResponse.capital)
            }
            if let citizenDay = fortuneAPIResponse.citizenDay {
                HStack(spacing: 0) {
                    Text("市民の日：")
                    Spacer()
                    Text(citizenDay.month.description + "月")
                    + Text(citizenDay.day.description + "日")
                }
            }
            HStack(spacing: 0) {
                Text("内陸県：")
                Spacer()
                Text(fortuneAPIResponse.hasCoastLine == false ? "はい" : "いいえ")
            }
            Text(fortuneAPIResponse.brief)
            AsyncImage(
                url: fortuneAPIResponse.logoURL,
                transaction: .init(animation: .bouncy)
            ) { asyncImagePhase in
                switch asyncImagePhase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                case .failure(let error):
                    Text(error.localizedDescription)
                @unknown default:
                    fatalError()
                }
            }
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("占い結果")
    }
}

#Preview("Light") {
    NavigationStack {
        FortuneResultView(.sample)
    }
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    NavigationStack {
        FortuneResultView(.sample)
    }
    .preferredColorScheme(.dark)
}
