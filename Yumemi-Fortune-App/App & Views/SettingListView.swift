import SwiftUI
import SwiftData

struct SettingListView: View {
    @State private var viewModel: SettingListViewModel

    init(user: User, modelContext: ModelContext) {
        self._viewModel = .init(wrappedValue: .init(user: user, modelContext: modelContext))
    }

    var body: some View {
        NavigationStack {
            Form {
                nameSectionContent
                birthdaySectionContent
                bloodTypeSectionContent
                specialThanksSectionContent
            }
            .navigationTitle("ユーザー設定")
            .toolbarTitleDisplayMode(.inlineLarge)
            .navigationDestination(isPresented: $viewModel.isEditingName) {
                NameEditView(
                    user: viewModel.user,
                    modelContext: viewModel.modelContext
                )
                .navigationTitle("編集モード")
                .navigationBarTitleDisplayMode(.inline)
            }
            .safeAreaInset(edge: .bottom) {
                Button("全てのデータを削除", role: .destructive, action: viewModel.didTapAccountDeleteButton)
                    .padding(.bottom)
            }
            .alert("確認", isPresented: $viewModel.isShowingAccountDeleteConfirmation) {
                Button("削除する", role: .destructive, action: viewModel.didTapAccountDeleteButtonInAlert)
            } message: {
                Text("全てのデータを削除しますか？")
            }
            .alert(
                "予期せぬエラーが発生しました。",
                isPresented: $viewModel.isShowingUnexpectedErrorAlert,
                actions: {}
            )
        }
    }

    var nameSectionContent: some View {
        Section {
            HStack(spacing: 0) {
                Text(viewModel.user.name)
                Spacer()
                Text("編集") // ※1
                    .foregroundStyle(Color.accentColor)
                    .onTapGesture(perform: viewModel.didTapEditNameButton)
            }
        } header: {
            Text("名前")
        }
    }

    @ViewBuilder
    var birthdaySectionContent: some View {
        if let birthdayBinding = viewModel.birthdayBinding {
            Section {
                DatePicker("誕生日", selection: birthdayBinding, in: ...Date.now, displayedComponents: .date)
                    .environment(\.locale, .init(identifier: "ja_JP"))
            } header: {
                Text("誕生日")
            }
        }
    }

    var bloodTypeSectionContent: some View {
        Section {
            Picker("血液型", selection: viewModel.bloodTypeBinding) {
                ForEach(BloodType.allCases, id: \.self) { bloodType in
                    Text(bloodType.rawValue)
                        .tag(bloodType)
                }
            }
        } header: {
            Text("血液型")
        }
    }

    var specialThanksSectionContent: some View {
        Section {
            navigationLinkRow(
                title: "イラストAC",
                comment: "こちらで提供されている占い師の画像を使用させていただきました。",
                links: [("Web Site", "https://www.ac-illust.com/main/detail.php?id=25205535&word=水晶占いをする女性占い師#goog_rewarded")]
            )
            navigationLinkRow(
                title: "効果音ラボ",
                comment: "こちらで提供されている効果音を占い取得時に使用させていただきました。",
                links: [("Web Site",  "https://soundeffect-lab.info/sound/anime/")]
            )
            navigationLinkRow(
                title: "Pow Animation",
                comment: "こちらで提供されているアニメーションを占い取得時に使用させていただきました。",
                links: [("Web Site",  "https://movingparts.io/pow"), ("GitHub",  "https://github.com/EmergeTools/Pow")]
            )
            navigationLinkRow(
                title: "日本地図無料イラスト素材集",
                comment: "こちらで提供されている都道府県の画像を使用させていただきました。",
                links: [("Web Site",  "https://japan-map.com")]
            )
            navigationLinkRow(
                title: "FortuneAPI",
                comment: "OpenAPI Document",
                links: [("Web Site",  "https://yumemi-inc.github.io/ios-junior-engineer-codecheck-backend/openapi.html")]
            )
        } header: {
            Text("謝辞")
        }
    }


    func navigationLinkRow(
        title: String,
        comment: String,
        links: [(labelString: String, linkString: String)]
    ) -> some View {
        NavigationLink(title) {
            List {
                VStack(alignment: .leading, spacing: .zero) {
                    Text(comment)
                        .padding(.bottom)
                    Grid(alignment: .leading) {
                        ForEach(links, id: \.labelString) { link in
                            GridRow {
                                Text(link.labelString + ":")
                                if let url = URL(string: link.linkString) {
                                    Link(link.linkString, destination: url)
                                } else {
                                    Text(link.linkString)
                                }
                            }
                            .lineLimit(1)
                            .textScale(.secondary)
                        }
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private struct SettingListViewWrapper: View {
    @Environment(\.modelContext) private var modelContext
    let user = try! User(name: "Naruto", birthday: .today, bloodType: .a)

    var body: some View {
        SettingListView(user: user, modelContext: modelContext)
    }
}

#Preview {
    SettingListViewWrapper()
}

/// ※1: Buttonを使用するとタップ領域が列全体となるため、Textを使用する。
