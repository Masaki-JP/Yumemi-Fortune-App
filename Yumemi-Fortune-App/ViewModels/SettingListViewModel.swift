import SwiftUI
import SwiftData

@MainActor @Observable
final class SettingListViewModel {

    /// Access Level
    let user: User
    let modelContext: ModelContext

    var isEditingName = false
    var isShowingDeleteConfirmation = false

    var birthdayBinding: Binding<Date>? {
        guard let birthdayDate = user.birthday.asDate else { return nil }

        return .init(get: { birthdayDate }, set: { self.user.updateBirthday(to: .init($0)) })
    }

    var bloodTypeBinding: Binding<BloodType> {
        .init(get: { self.user.bloodType }, set: { self.user.updateBloodType(to: $0) })
    }

    init(user: User, modelContext: ModelContext) {
        self.user = user
        self.modelContext = modelContext
    }

    func didTapEditNameButton() {
        isEditingName = true
    }

    func didTapSaveButton(newName: String, dismissAction: (() -> Void)? = nil) {
        user.updateName(to: newName)
        dismissAction?()
    }

    func didTapAccountDeleteButton() {
        isShowingDeleteConfirmation = true
    }

    func didTapAccountDeleteButtonInAlert() {
        modelContext.delete(user)
    }
}
