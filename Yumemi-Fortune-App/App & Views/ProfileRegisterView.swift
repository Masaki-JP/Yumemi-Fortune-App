import SwiftUI
import SwiftData

@MainActor
struct ProfileRegisterView: View {
    @State private var viewModel: ProfileRegisterViewModel
    @FocusState private var isFocusedTextField

    init(modelContext: ModelContext) {
        self._viewModel = .init(wrappedValue: .init(modelContext: modelContext))
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("名前", text: $viewModel.name)
                    .focused($isFocusedTextField)
                DatePicker("誕生日", selection: $viewModel.birthday, in: ...Date.now, displayedComponents: .date)
                    .environment(\.locale, .init(identifier: "ja_JP"))
                Picker("血液型", selection: $viewModel.bloodType, content: pickerContent)
            }
            .navigationTitle("ユーザー情報")
            .alert(
                "予期せぬエラーが発生しました。",
                isPresented: $viewModel.isShowingUnknownErrorAlert,
                actions: {}
            )
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("登録", action: viewModel.didTapRegisterButton)
                }
                ToolbarItem(placement: .keyboard) {
                    Text("完了")
                        .foregroundStyle(Color.accentColor)
                        .onTapGesture {
                            isFocusedTextField = false
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
        }
    }

    @ViewBuilder
    func pickerContent() -> some View {
        if viewModel.bloodType == nil {
            Text("選択してください。")
                .tag(BloodType?.none)
        }
        ForEach(BloodType.allCases, id: \.self) { bloodType in
            Text(bloodType.rawValue)
                .tag(BloodType?.some(bloodType))
        }
    }
}

struct ProfileRegisterViewWrapper: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ProfileRegisterView(modelContext: modelContext)
    }
}

#Preview {
    ProfileRegisterViewWrapper()
}
