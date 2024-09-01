import SwiftUI


struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationStack {
            Form {
                TextField("名前", text: $viewModel.name)
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
                }
            }
        }
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
}

#Preview {
    ContentView()
}
