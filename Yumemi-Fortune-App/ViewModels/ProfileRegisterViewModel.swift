import Foundation
import SwiftData

@MainActor @Observable
final class ProfileRegisterViewModel {
    var name = "ナルト"
    var birthday = Date.now
    var bloodType: BloodType? = .a
    var isShowingUnknownErrorAlert = false
    let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func didTapRegisterButton() {
        guard let bloodType else { isShowingUnknownErrorAlert = true; return }
        do {
            let user = User(name: name, birthday: .init(birthday), bloodType: bloodType)
            modelContext.insert(user)
            try modelContext.save()
        } catch {
            isShowingUnknownErrorAlert = true
        }
    }
}
