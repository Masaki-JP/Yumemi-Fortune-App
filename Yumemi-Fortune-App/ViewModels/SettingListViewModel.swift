import SwiftUI
import SwiftData

@MainActor @Observable
final class SettingListViewModel {

    /// Access Level
    let user: User
    let modelContext: ModelContext

    var isEditingName = false
    var isShowingDeleteConfirmation = false

    var isShowingUnexpectedErrorAlert = false

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

    func didTapAccountDeleteButton() {
        isShowingDeleteConfirmation = true
    }

    func didTapAccountDeleteButtonInAlert() {
        do {
            modelContext.delete(user)
            try modelContext.save()
        } catch {
            isShowingUnexpectedErrorAlert = true
        }
    }
}
