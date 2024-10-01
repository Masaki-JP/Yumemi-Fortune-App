import Foundation
import SwiftData

/// ``NameEditView``で使用するViewModel。
///
@MainActor @Observable
final class NameEditViewModel {
    let user: User
    let modelContext: ModelContext
    
    /// `user`の元々の名前。
    ///
    let originName: String

    /// テキストフィールドにバインディングする文字列。`user`の新しい名前になる。
    ///
    var newName: String

    /// 予期せぬエラー発生時のアラートの表示フラグ。
    ///
    var isShowingUnexpectedErrorAlert = false

    /// 「保存」ボタンの無効化フラグ。
    ///
    var isSaveButtonDisabled: Bool {
        newName.isEmpty || originName == newName
    }

    init(user: User, modelContext: ModelContext) {
        self.user = user
        self.modelContext = modelContext

        self.originName = user.name
        self.newName = user.name
    }

    /// テキストフィールドの「X」マークが押された時の処理。
    ///
    /// テキストフィールドの入力を削除する。
    ///
    func didTapXCircleMark() {
        newName.removeAll()
    }


    /// 「保存」ボタンが押された時の処理。
    ///
    /// - Parameter completionHandler: 例外を投げることなく処理が終了した時に実行される処理。
    ///
    func didTapSaveButton(onCompleted completionHandler: () -> Void) {
        do {
            user.updateName(to: newName)
            try modelContext.save()
            completionHandler()
        } catch {
            isShowingUnexpectedErrorAlert = true
        }
    }
}
