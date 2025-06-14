import Foundation

protocol EventAPIProtocol {
    func fetchEvents(completion: @escaping (Result<[Event], Error>) -> Void)
}

final class ShowEventsEventService: EventAPI, EventAPIProtocol {
    func fetchEvents(completion: @escaping (Result<[Event], any Error>) -> Void) {
        fetch { result in
            completion(result)
        }
    }
}
