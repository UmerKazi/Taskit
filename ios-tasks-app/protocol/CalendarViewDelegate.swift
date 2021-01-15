

import Foundation

protocol CalendarViewDelegate: class {
    func calendarViewDidSelectDate(date: Date)
    func calendarViewDidTapRemoveButton()
}
