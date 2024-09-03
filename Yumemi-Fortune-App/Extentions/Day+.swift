import Foundation

extension Day {
    func validate() throws {
        let dateComponents = DateComponents(calendar: Self.calendar, timeZone: Self.calendar.timeZone, year: self.year, month: self.month, day: self.day)

        guard dateComponents.isValidDate else {
            throw Self.Error.invalidDay
        }

        guard let date = dateComponents.date else {
            let msg = "\(#function): 有効なDateComponentからDateを生成できませんでした。"
            throw Self.Error.unexpectedError(msg)
        }

        guard date < .now else {
            throw Self.Error.invalidDay
        }
    }

    static var sample: Self {
       try! .init(year: 2020, month: 10, day: 10)
    }
}
