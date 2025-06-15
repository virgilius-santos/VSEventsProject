import Foundation
@testable import VSEventsProject

final class DetailAPIProtocolMock: ShowDetailsAPIProtocol {
    enum Message: Equatable {
        case fetch(_ source: Event)
        case checkIn(_ source: User)
    }
    
    private(set) var messages: [Message] = [] {
        didSet {
            anyMessages.appendLast(of: messages)
        }
    }
    
    var anyMessages = AnyMessage()
    
    private(set) var fetchRequests: [Any] = []
    func fetchEvent(_ source: Event, completion: @escaping (Result<Event, Error>) -> Void) {
        messages.append(.fetch(source))
        fetchRequests.append(completion)
    }
    func simulateFetchResponse<T>(with result: Result<T, Error>, at index: Int = 0) {
        let completion = fetchRequests[safe: index] as? ((Result<T, Error>) -> Void)
        completion?(result)
    }
    
    private(set) var checkInRequests: [(Result<CheckIn, Error>) -> Void] = []
    func checkIn(user: User, completion: @escaping (Result<CheckIn, Error>) -> Void) {
        messages.append(.checkIn(user))
        checkInRequests.append(completion)
    }
    func simulateCheckInResponse(with result: Result<CheckIn, Error>, at index: Int = 0) {
        let completion = checkInRequests[safe: index]
        completion?(result)
    }
}
