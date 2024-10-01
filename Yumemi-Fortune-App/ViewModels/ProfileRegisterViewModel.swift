import Foundation
import SwiftData

@MainActor @Observable
final class ProfileRegisterViewModel {
    var name = ""
    var birthday = Date.now
    var bloodType: BloodType? = nil

    let modelContext: ModelContext

    /// 予期せぬエラー発生時のアラートを表示フラグ。
    ///
    var isShowingUnexpectedErrorAlert = false

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
        guard let bloodType else { isShowingUnexpectedErrorAlert = true; return }

        do {
            let user = User(name: name, birthday: .init(birthday), bloodType: bloodType)
            modelContext.insert(user)
            try modelContext.save()
        } catch {
            isShowingUnexpectedErrorAlert = true
        }
    }
}
