import SwiftUI
import SwiftData

/// ``SettingListView``で使用するViewModel。
///
@MainActor @Observable
final class SettingListViewModel {
    let user: User
    let modelContext: ModelContext

    /// ``NameEditView``の表示フラグ。
    ///
    var isEditingName = false

    /// アカウント削除時の確認ダイアログの表示フラグ。
    ///
    var isShowingAccountDeleteConfirmation = false

    /// 予期せぬエラー発生時のアラートの表示フラグ。
    ///
    var isShowingUnexpectedErrorAlert = false

    /// `user.birthday`のバインディング
    ///
    /// バインディングの作成に失敗した場合は、`nil`を返す。
    ///
    var birthdayBinding: Binding<Date>? {
        guard let birthdayDate = user.birthday.asDate else { return nil }

        return .init(get: { birthdayDate }, set: { self.user.updateBirthday(to: .init($0)) })
    }

    /// `user.bloodType`のバインディング
    ///
    var bloodTypeBinding: Binding<BloodType> {
        .init(get: { self.user.bloodType }, set: { self.user.updateBloodType(to: $0) })
    }

    init(user: User, modelContext: ModelContext) {
        self.user = user
        self.modelContext = modelContext
    }

    /// 「編集」ボタンが押された時の処理。
    ///
    /// プッシュ遷移で``NameEditView``を表示する。
    ///
    func didTapEditNameButton() {
        isEditingName = true
    }

    /// 「全てのデータを削除」ボタンが押された時の処理。
    ///
    /// アカウント削除の確認ダイアログを表示する。
    ///
    func didTapAccountDeleteButton() {
        isShowingAccountDeleteConfirmation = true
    }

    /// アカウント削除の確認ダイアログの「削除する」ボタンが押された時の処理。
    ///
    /// 保持している``User``の削除を行う。失敗した場合は、予期せぬエラーの発生時のアラートを表示する。
    ///
    func didTapAccountDeleteButtonInAlert() {
        do {
            modelContext.delete(user)
            try modelContext.save()
        } catch {
            isShowingUnexpectedErrorAlert = true
        }
    }
}
