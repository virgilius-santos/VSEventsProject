import Foundation

struct Cupom: Decodable, Identifiable, Equatable {
    let id: String
    let eventId: String
    let discount: Int
}
