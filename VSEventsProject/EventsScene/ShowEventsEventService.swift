import Foundation

protocol EventAPIProtocol {
    func fetchEvents(completion: @escaping (Result<[Event], Error>) -> Void)
}

final class ShowEventsEventService: EventAPIProtocol {
    let getEventStringURL = "https://vsevents.free.beeceptor.com/api/events"
    let api: APIProtocol
    
    init(api: APIProtocol = EventAPI()) {
        self.api = api
    }
    
    func fetchEvents(completion: @escaping (Result<[Event], any Error>) -> Void) {
        api.fetch(endpoint: .init(method: .get, url: getEventStringURL)) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                completion(mapResult(data))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
    
    func mapResult(_ data: Data) -> Result<[Event], any Error> {
        do {
            let decodedObject = try [Event].decoder(json: data)
            return .success(decodedObject)
        } catch {
            return .error(error)
        }
    }
}
