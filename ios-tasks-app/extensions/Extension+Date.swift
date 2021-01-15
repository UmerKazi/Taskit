
import Foundation

extension Date {
    
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d, yyyy"
        return formatter.string(from: self)
    }
    
    func toRelativeString() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let today = Date()
        return formatter.localizedString(for: self, relativeTo: today)
    }
    
    func isOverDue() -> Bool {
        let today = Date()
        return self < today
    }
    
}
