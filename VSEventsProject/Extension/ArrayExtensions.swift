import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {  // Changed to use labeled parameter correctly
        indices.contains(index) ? self[index] : nil
    }
}
