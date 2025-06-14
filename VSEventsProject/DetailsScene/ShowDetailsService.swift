import Foundation

protocol DetailAPIProtocol {
    func fetchEvent(_ event: Event, completion: @escaping (Swift.Result<Event, Error>) -> Void)
    func checkIn(user: User, completion: @escaping (Result<CheckIn, Error>) -> Void)
}

extension Endpoint {
    static func event(_ event: Event) -> Self {
        Endpoint(
            method: .get,
            url: "https://vsevents.free.beeceptor.com/api/events/\(event.id)"
        )
    }
    
    static func checkIn(_ user: User) throws -> Self {
        Endpoint(
            method: .post,
            url: "https://vsevents.free.beeceptor.com/api/checkin",
            parameters: try user.toData()
        )
    }
}

final class ShowDetailsService: DetailAPIProtocol {
    let api: APIProtocol
    
    init(api: APIProtocol = API()) {
        self.api = api
    }
    
    func fetchEvent(_ event: Event, completion: @escaping (Result<Event, any Error>) -> Void) {
        api.fetch(endpoint: Endpoint.event(event)) { [weak self] result in
            guard self != nil else { return }
            completion(result.decodeTo(Event.self))
        }
    }
        
    func checkIn(user: User, completion: @escaping (Result<CheckIn, any Error>) -> Void) {
        api.fetch(endpoint: try Endpoint.checkIn(user)) { [weak self] result in
            guard self != nil else { return }
            completion(result.decodeTo(CheckIn.self))
        }
    }
}
