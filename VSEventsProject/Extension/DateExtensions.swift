import Foundation

extension Date {
    func toString() -> String {
        let format = "dd/MM/yyyy"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
