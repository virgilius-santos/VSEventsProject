import Foundation
@testable import VSEventsProject

final class EventAPIProtocolMock: EventAPIProtocol {
    private(set) var receivedRequests: [(Result<[Event], Error>) -> Void] = []
    
    func fetchEvents(completion: @escaping (Result<[Event], Error>) -> Void) {
        receivedRequests.append(completion)
    }
    
    func simulateNetworkResponse(with result: Result<[Event], Error>, at index: Int = 0) {
        let completion = receivedRequests[safe: index]
        completion?(result)
    }
}
