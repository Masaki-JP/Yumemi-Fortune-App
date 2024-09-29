import SwiftUI
import SwiftData

@MainActor
struct FortuneResultListView<FortuneFetcherObject: FortuneFetcherProtocol & Sendable>: View {
    @State private var viewModel: FortuneResultListViewModel<FortuneFetcherObject>
    @Environment(\.modelContext) private var modelContext

    init(
        user: User,
        modelContext: ModelContext,
        fortuneFetcher: FortuneFetcherObject = FortuneFetcher()
    ) {
        self._viewModel = .init(
            wrappedValue: .init(
                user: user,
                modexContext: modelContext,
                fortuneFetcher: fortuneFetcher
            )
        )
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.user.fortuneResultList.map { $0 }, id: \.key) { key, value in
                    NavigationLink("\(key.japaneseFormatted)（\(value.compatiblePrefecture)）") {
                        FortuneResultView(value)
                            .navigationTitle(key.japaneseFormatted)
                            .navigationBarTitleDisplayMode(.inline)
                    }
                }
            }
            .navigationTitle("過去の占い")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                if viewModel.user.fortuneResultList.isEmpty == false,
                   viewModel.user.todayFortune == nil {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("占う", action: viewModel.didTapGetFortuneButton)
                    }
                }
            }
            .fullScreenCover(isPresented: $viewModel.isShowingGetFortuneResultView) {
                GetFortuneView(user: viewModel.user, modelContext: modelContext)
            }
            .overlay {
                if viewModel.user.fortuneResultList.isEmpty {
                    fortunePromptView(action: viewModel.didTapGetFortuneButton)
                }
            }
        }
    }
}

struct FortuneResultListViewWrapper: View {
    @Environment(\.modelContext) private var modelContext
    let user = User(name: "Naruto", birthday: .today, bloodType: .a)

    var body: some View {
        FortuneResultListView(user: user, modelContext: modelContext)
    }
}

#Preview {
    FortuneResultListViewWrapper()
}
