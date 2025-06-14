import Foundation

struct Person: Decodable, Identifiable, Equatable {
    let id: String
    let eventId: String
    let name: String
    let picture: String
}
