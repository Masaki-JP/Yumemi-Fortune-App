import SwiftUI


struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.colorScheme) private var colorScheme
    @FocusState private var isFocusedNameTextField

    var body: some View {
        NavigationStack {
            Form {
                TextField("名前", text: $viewModel.name)
                    .focused($isFocusedNameTextField)
                DatePicker("誕生日", selection: $viewModel.birthday)
                Picker("血液型", selection: $viewModel.bloodType, content: pickerContent)
            }
            .navigationTitle("Fortune")
            .toolbarTitleDisplayMode(.inlineLarge)
            .navigationDestination(item: $viewModel.fortuneAPIResponse, destination: FortuneResultView.init)
            .alert("血液型を設定してください。", isPresented: $viewModel.unSetBloodTypeErrorAlert, actions: {})
            .alert("予期せぬエラーが発生しました。", isPresented: $viewModel.unexpectedErrorAlert, actions: {})
            .alert("⚠️ エラー発生",
                   isPresented: .init(
                    get: { viewModel.fortuneAPIClientError != nil },
                    set: { if $0 == false { viewModel.fortuneAPIClientError = nil }}),
                   actions: { Button("閉じる") {}},
                   message: { if let fortuneAPIClientError = viewModel.fortuneAPIClientError { Text(viewModel.alertMessage(fortuneAPIClientError)) }}
            )
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("占う", action: viewModel.didTapFortuneButton)
                        .fontWeight(viewModel.isGetFortuneButtonDisabled ? nil : .bold)
                        .disabled(viewModel.isGetFortuneButtonDisabled)
                }
                ToolbarItem(placement: .keyboard) {
                    Text("完了") // Don't replace this with Button.
                        .onTapGesture { isFocusedNameTextField = false }
                        .foregroundStyle(.blue)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
        }
        .overlay(content: backgroundContent)
        .onDisappear { viewModel.onDisAppear() }
        .onChange(of: scenePhase) { oldValue, _ in
            if oldValue == .active { viewModel.onChangeToNotActive() }
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

    @ViewBuilder
    func backgroundContent() -> some View {
        if viewModel.isFetchingFortune == true {
            Color.black
                .opacity(colorScheme == .light ? 0.1 : 0.3)
                .ignoresSafeArea()

            VStack {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(width: 50, height: 50)
                Text("占い結果を取得中...")
                    .foregroundStyle(.secondary)
                    .fontWeight(.semibold)
            }
        }
    }
}

#Preview {
    ContentView()
}
