import SwiftUI
import SwiftData

struct FortuneResultListView: View {
    @State private var viewModel: FortuneResultListViewModel

    init(user: User, modelContext: ModelContext) {
        self._viewModel = .init(wrappedValue: .init(user: user, modelContext: modelContext))
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
            .fullScreenCover(isPresented: $viewModel.isShowingGetFortuneView) {
                GetFortuneView(user: viewModel.user, modelContext: viewModel.modelContext)
            }
            .overlay {
                if viewModel.user.fortuneResultList.isEmpty {
                    fortunePromptView(action: viewModel.didTapGetFortuneButton)
                }
            }
        }
    }
}

struct FortuneResultListViewWrapper1: View {
    private let user = try! User(
        name: "Naruto",
        birthday: try! .init(year: 2000, month: 1, day: 1),
        bloodType: .a,
        fortuneResultList: [
            try! .init(year: 2020, month: 1, day: 1) : .sample1,
            try! .init(year: 2020, month: 1, day: 2) : .sample2,
            try! .init(year: 2020, month: 1, day: 3) : .sample3,
        ]
    )
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        FortuneResultListView(user: user, modelContext: modelContext)
    }
}

struct FortuneResultListViewWrapper2: View {
    private let user = try! User(
        name: "Naruto",
        birthday: .today,
        bloodType: .a,
        fortuneResultList: [:]
    )
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        FortuneResultListView(user: user, modelContext: modelContext)
    }
}

#Preview("Case1") {
    FortuneResultListViewWrapper1()
}

#Preview("Case2") {
    FortuneResultListViewWrapper2()
}
