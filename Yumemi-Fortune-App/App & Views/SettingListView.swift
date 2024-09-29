import SwiftUI
import SwiftData

@MainActor
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
            }
            .navigationTitle("ユーザー設定")
            .toolbarTitleDisplayMode(.inlineLarge)
            .navigationDestination(isPresented: $viewModel.isEditingName) {
                NameEditView(
                    originName: viewModel.user.name,
                    didTapSaveButton: viewModel.didTapSaveButton
                )
                .navigationTitle("編集モード")
                .navigationBarTitleDisplayMode(.inline)
            }
            .safeAreaInset(edge: .bottom) {
                Button("全てのデータを削除", role: .destructive, action: viewModel.didTapAccountDeleteButton)
                    .padding(.bottom)
            }
            .alert("確認", isPresented: $viewModel.isShowingDeleteConfirmation) {
                Button("削除する", role: .destructive, action: viewModel.didTapAccountDeleteButtonInAlert)
            } message: {
                Text("全てのデータを削除しますか？")
            }
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
}

@MainActor
struct NameEditView: View {
    private let originName: String
    private let didTapSaveButton: (_ newName: String, _ dismissAction: (() -> Void)?) -> Void

    @State private var newName: String
    @Environment(\.dismiss) private var dismiss

    init(
        originName: String,
        didTapSaveButton: @escaping (_ newName: String, _ dismissAction: (() -> Void)?) -> Void
    ) {
        self.originName = originName
        self.didTapSaveButton = didTapSaveButton

        self._newName = .init(wrappedValue: originName)
    }

    var body: some View {
        Form {
            Section {
                HStack(spacing: 0) {
                    TextField("例：田中　太郎", text: $newName)
                    Spacer()
                    Image(systemName: "x.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .foregroundStyle(.gray)
                        .onTapGesture { newName.removeAll() }
                }
            } header: {
                Text("新しい名前を入力")
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("保存") {
                    didTapSaveButton(newName, dismiss.callAsFunction)
                }
                .disabled(newName.isEmpty || originName == newName)
            }
        }
    }
}

private struct SettingListViewWrapper: View {
    @Environment(\.modelContext) private var modelContext
    let user = User(name: "Naruto", birthday: .today, bloodType: .a)

    var body: some View {
        SettingListView(user: user, modelContext: modelContext)
    }
}

#Preview {
    SettingListViewWrapper()
}

/// ※1: Buttonを使用するとタップ領域が列全体となるため、Textを使用する。
