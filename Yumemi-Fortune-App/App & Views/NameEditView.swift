import SwiftUI

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

#Preview {
    NameEditView(originName: "Naruto", didTapSaveButton: {_, _ in })
}
