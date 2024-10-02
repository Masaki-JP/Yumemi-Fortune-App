import SwiftUI
import SwiftData

@MainActor @Observable
final class ProfileRegisterViewModel {
    var name = ""
    var birthday = Date.now
    var bloodType: BloodType? = nil

    let modelContext: ModelContext
    
    /// エラー発生時のアラートの表示フラグとなる文字列。
    ///
    private(set) var errorAlertMessage = ""

    /// `errorAlertMessage`のバインディング。
    ///
    var errorAlertMessageBinding: Binding<Bool> {
        .init(
            get: { self.errorAlertMessage.isEmpty == false },
            set: { if $0 == false { self.errorAlertMessage.removeAll() } }
        )
    }

    /// 「登録」ボタンの無効化フラグ。
    ///
    var isRegisterButtonDisabled: Bool {
        !(name.isEmpty == false && bloodType != nil)
    }

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    /// 「登録」ボタンが押された時の処理。
    ///
    /// ``User``の生成及び永続化を行う。失敗した場合は、予期せぬエラー発生時のアラートを表示する。
    ///
    func didTapRegisterButton() {
        let unexpectedErrorAlertMessage = "予期せぬエラーが発生しました。"
        guard let bloodType else { errorAlertMessage = unexpectedErrorAlertMessage; return }

        do {
            let user = try User(name: name, birthday: .init(birthday), bloodType: bloodType)
            modelContext.insert(user)
            guard let _ = try? modelContext.save() else { errorAlertMessage = "データの保存に失敗しました。"; return }
        } catch {
            errorAlertMessage = switch error {
            case .noName: unexpectedErrorAlertMessage
            case .tooLongName: "名前は100文字未満で設定してください。"
            }
        }
    }
}
