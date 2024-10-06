import SwiftUI

struct FortuneResultView: View {
    private let viewModel: FortuneResultViewModel

    init(_ fortuneResult: FortuneResult) {
        self.viewModel = .init(fortuneResult)
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
                Text(viewModel.fortuneResult.briefWithoutSource)
            } header: {
                Text("都道府県の概要")
            } footer: {
                if let briefSource = viewModel.fortuneResult.briefSource {
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
        .task {
            await viewModel.onAppearAction()
        }
    }

    var prefectureRow: some View {
        HStack(spacing: 0) {
            Text("ラッキー都道府県：")
            Spacer()
            Text(viewModel.fortuneResult.compatiblePrefecture)
        }
    }

    var capitalRow: some View {
        HStack(spacing: 0) {
            Text("首都：")
            Spacer()
            Text(viewModel.fortuneResult.capital)
        }
    }

    @ViewBuilder
    var citizenDayRow: some View {
        if let citizenDay = viewModel.fortuneResult.citizenDay {
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
            Text(viewModel.fortuneResult.hasCoastLine == false ? "はい" : "いいえ")
        }
    }

    @ViewBuilder
    var logoImageRow: some View {
        switch viewModel.getPrefectureImageResult {
        case .none:
            ProgressView()
        case .success(let uiImage):
            Image(uiImage: uiImage)
                .resizable().scaledToFit()
        case .failure(let getPrefectureImageError):
            ContentUnavailableView(
                "エラー発生",
                systemImage: "x.circle",
                description: Text(getPrefectureImageError.message)
            )
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
