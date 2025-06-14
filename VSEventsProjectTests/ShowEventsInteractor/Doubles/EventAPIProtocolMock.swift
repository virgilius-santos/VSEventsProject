import Foundation
@testable import VSEventsProject

final class EventAPIProtocolMock: EventAPIProtocol {
    private(set) var receivedRequests: [Any] = []
    
    func fetch<T>(completion: @escaping (Result<[T], Error>) -> Void) where T: Decodable {
        receivedRequests.append(completion)
    }
    
    func simulateNetworkResponse<T>(with result: Result<[T], Error>, at index: Int = 0) {
        let completion = receivedRequests[safe: index] as? ((Result<[T], Error>) -> Void)
        completion?(result)
    }
}
