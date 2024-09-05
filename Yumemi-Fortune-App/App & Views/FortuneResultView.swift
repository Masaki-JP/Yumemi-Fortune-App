import SwiftUI

struct FortuneResultView: View {
    private let fortuneResult: FortuneResult

    init(_ fortuneResult: FortuneResult) {
        self.fortuneResult = fortuneResult
    }

    var body: some View {
        List {
            prefectureRow
            capitalRow
            citizenDayRow
            hasCoastLineRow
            logoImageRow
                .frame(maxWidth: .infinity)
        }
        .navigationTitle("占い結果")
    }

    var prefectureRow: some View {
        HStack(spacing: 0) {
            Text("相性のいい都道府県：")
            Spacer()
            Text(fortuneResult.compatiblePrefecture)
        }
    }

    var capitalRow: some View {
        HStack(spacing: 0) {
            Text("首都：")
            Spacer()
            Text(fortuneResult.capital)
        }
    }

    @ViewBuilder
    var citizenDayRow: some View {
        if let citizenDay = fortuneResult.citizenDay {
            HStack(spacing: 0) {
                Text("市民の日：")
                Spacer()
                Text(citizenDay.month.description + "月")
                + Text(citizenDay.day.description + "日")
            }
        }
    }

    var hasCoastLineRow: some View {
        HStack(spacing: 0) {
            Text("内陸県：")
            Spacer()
            Text(fortuneResult.hasCoastLine == false ? "はい" : "いいえ")
        }
    }

    var briefRow: some View {
        Text(fortuneResult.brief)
    }

    var logoImageRow: some View {
        AsyncImage(
            url: fortuneResult.logoURL,
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
