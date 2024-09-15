import SwiftUI

struct FortuneResultView: View {
    private let fortuneResult: FortuneResult

    init(_ fortuneResult: FortuneResult) {
        self.fortuneResult = fortuneResult
    }

    var body: some View {
        List {
            Section {
                prefectureRow
                capitalRow
                citizenDayRow
                hasCoastLineRow
            } header: {
                Text("占い結果")
            }
            Section {
                Text(fortuneResult.briefWithoutSource)
            } header: {
                Text("都道府県の概要")
            } footer: {
                if let briefSource = fortuneResult.briefSource {
                    Text(briefSource)
                        .font(.caption)
                }
            }
            Section {
                logoImageRow.frame(maxWidth: .infinity)
            } header: {
                Text("都道府県の形")
            } footer: {
                Text("※画像元: 日本地図の無料イラスト素材集")
                    .font(.caption)
            }
        }
    }

    var prefectureRow: some View {
        HStack(spacing: 0) {
            Text("ラッキー都道府県：")
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
        FortuneResultView(.sample1)
    }
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    NavigationStack {
        FortuneResultView(.sample1)
    }
    .preferredColorScheme(.dark)
}
