import Foundation

protocol EventAPIProtocol: AnyObject {
    func fetchEvents(completion: @escaping (Result<[Event], Error>) -> Void)
}

extension Endpoint {
    static let events = Endpoint(
        method: .get,
        url: "events"
    )
}

final class ShowEventsEventService: EventAPIProtocol {
    let api: APIProtocol
    
    init(api: APIProtocol) {
        self.api = api
    }
    
    func fetchEvents(completion: @escaping (Result<[Event], any Error>) -> Void) {
        api.fetch(endpoint: Endpoint.events) { [weak self] result in
            guard self != nil else { return }
            completion(result.decodeTo([Event].self))
        }
    }
}
