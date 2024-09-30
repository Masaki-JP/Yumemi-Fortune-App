import Foundation
import SwiftData

@MainActor @Observable
final class ProfileRegisterViewModel {
    var name = ""
    var birthday = Date.now
    var bloodType: BloodType? = nil
    var isShowingUnexpectedErrorAlert = false
    let modelContext: ModelContext

    var isRegisterButtonDisabled: Bool {
        !(name.isEmpty == false && bloodType != nil)
    }

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

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
