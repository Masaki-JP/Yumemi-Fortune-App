import Foundation
import SwiftData

@MainActor @Observable
final class NameEditViewModel {
    let user: User
    private let modelContext: ModelContext

    let originName: String
    var newName: String

    var isShowingUnexpectedErrorAlert = false

    var isSaveButtonDisabled: Bool {
        newName.isEmpty || originName == newName
    }

    init(user: User, modelContext: ModelContext) {
        self.user = user
        self.modelContext = modelContext

        self.originName = user.name
        self.newName = user.name
    }

    func didTapXCircleMark() {
        newName.removeAll()
    }

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
