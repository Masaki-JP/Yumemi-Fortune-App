import SwiftUI
import SwiftData

@MainActor
struct NameEditView: View {
    @State private var viewModel: NameEditViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(
        user: User,
        modelContext: ModelContext
    ) {
        self._viewModel = .init(wrappedValue: .init(user: user, modelContext: modelContext))
    }
    
    var body: some View {
        Form {
            Section {
                HStack(spacing: 0) {
                    TextField("例：田中　太郎", text: $viewModel.newName)
                    Spacer()
                    Image(systemName: "x.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                        .foregroundStyle(.gray)
                        .onTapGesture(perform: viewModel.didTapXCircleMark)
                }
            } header: {
                Text("新しい名前を入力")
            }
        }
        .alert(
            "予期せぬエラーが発生しました。",
            isPresented: $viewModel.isShowingUnexpectedErrorAlert,
            actions: {}
        )
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("保存") {
                    viewModel.didTapSaveButton(onCompleted: dismiss.callAsFunction)
                }
                .disabled(viewModel.isSaveButtonDisabled)
            }
        }
    }
}

private struct NameEditViewWrapper: View {
    let user = User(name: "Naruto", birthday: .today, bloodType: .a)
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NameEditView(user: user, modelContext: modelContext)
    }
}

#Preview {
    NameEditViewWrapper()
}
