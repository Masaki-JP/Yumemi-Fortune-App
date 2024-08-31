import SwiftUI

struct ContentView: View {
    @State private var name = ""
    @State private var birthday: Date = .init()
    @State private var bloodType: BloodType? = nil
    @State private var fortuneAPIResponse: FortuneAPIResponse? = nil
    @State private var fortuneAPIClientError: FortuneAPIClient.Error? = nil
    @State private var unSetBloodTypeErrorAlert = false
    @State private var unexpectedErrorAlert = false

    var body: some View {
        NavigationStack {
            Form {
                TextField("名前", text: $name)
                DatePicker("誕生日", selection: $birthday)
                Picker("血液型", selection: $bloodType, content: pickerContent)
            }
            .navigationTitle("Fortune")
            .toolbarTitleDisplayMode(.inlineLarge)
            .navigationDestination(item: $fortuneAPIResponse, destination: FortuneResultView.init)
            .alert("血液型を設定してください。", isPresented: $unSetBloodTypeErrorAlert, actions: {})
            .alert("予期せぬエラーが発生しました。", isPresented: $unexpectedErrorAlert, actions: {})
            .alert("⚠️ エラー発生",
                   isPresented: .init(
                    get: { fortuneAPIClientError != nil },
                    set: { if $0 == false { fortuneAPIClientError = nil }}),
                   actions: { Button("閉じる") {}},
                   message: { if let fortuneAPIClientError { Text(alertMessage(fortuneAPIClientError)) }}
            )
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("占う", action: didTapFortuneButton)
                }
            }
        }
    }

    @ViewBuilder
    func pickerContent() -> some View {
        if bloodType == nil {
            Text("選択してください。")
                .tag(BloodType?.none)
        }
        ForEach(BloodType.allCases, id: \.self) { bloodType in
            Text(bloodType.rawValue)
                .tag(BloodType?.some(bloodType))
        }
    }

    func didTapFortuneButton() {
        Task {
            do {
                let apiClient = FortuneAPIClientStub(.failure(.decodeFailure))
                let birthday = Day(birthday)
                guard let bloodType else {
                    unSetBloodTypeErrorAlert = true
                    return
                }

                fortuneAPIResponse = try await apiClient.fetchFortune(
                    name: name,
                    birthday: birthday,
                    bloodType: bloodType
                )
            } catch let error as FortuneAPIClient.Error {
                fortuneAPIClientError = error
            } catch {
                fatalError()
            }
        }
    }

    func alertMessage(_ fortuneAPIClientError: FortuneAPIClient.Error) -> String {
        switch fortuneAPIClientError {
        case .noName:
            "名前を入力してください。"
        case .tooLongName:
            "入力された名前が長すぎます。名前は〇文字以上〇文字以下にしてください。"
        case .possibleNetworkError:
            "占い結果を受信できませんでした。ネットワーク状態のいい場所に移動すると、このエラーは解消される可能性があります。"
        case .invalidBirthday, .urlInitializeFailure, .encodeFailure, .unexpectedResponse, .decodeFailure, .unexpectedError:
            "予期せぬエラーが発生しました。"
        }
    }
}

#Preview {
    ContentView()
}
