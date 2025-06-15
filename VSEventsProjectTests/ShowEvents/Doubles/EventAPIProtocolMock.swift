import Foundation
@testable import VSEventsProject

final class EventAPIProtocolMock: EventAPIProtocol {
    enum Message: Equatable {
        case fetchEvents
    }
    
    private(set) var messages: [Message] = [] {
        didSet {
            anyMessages.appendLast(of: messages)
        }
    }
    
    var anyMessages = AnyMessage()
    
    private(set) var receivedRequests: [(Result<[Event], Error>) -> Void] = []
    func fetchEvents(completion: @escaping (Result<[Event], Error>) -> Void) {
        messages.append(.fetchEvents)
        receivedRequests.append(completion)
    }
    func simulateNetworkResponse(with result: Result<[Event], Error>, at index: Int = 0) {
        let completion = receivedRequests[safe: index]
        completion?(result)
    }
}
