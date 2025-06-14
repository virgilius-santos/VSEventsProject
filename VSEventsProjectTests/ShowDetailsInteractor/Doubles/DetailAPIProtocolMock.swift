import Foundation
@testable import VSEventsProject

final class DetailAPIProtocolMock: DetailAPIProtocol {
    enum Message: Equatable {
        case fetch(_ source: Identifiable)
        case checkIn(_ source: Any)
        
        static func == (lhs: DetailAPIProtocolMock.Message, rhs: DetailAPIProtocolMock.Message) -> Bool {
            switch (lhs, rhs) {
            case (.fetch(let l), .fetch(let r)):
                return areEqual(l, r)
            case (.checkIn(let l), .checkIn(let r)):
                return areEqual(l, r)
            default:
                return false
            }
        }
    }
    
    private(set) var messages: [Message] = [] {
        didSet {
            anyMessages.appendLast(of: messages)
        }
    }
    
    var anyMessages = AnyMessage()
    
    private(set) var fetchRequests: [Any] = []
    func fetch<T>(source: Identifiable, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        messages.append(.fetch(source))
        fetchRequests.append(completion)
    }
    func simulateFetchResponse<T>(with result: Result<T, Error>, at index: Int = 0) {
        let completion = fetchRequests[safe: index] as? ((Result<T, Error>) -> Void)
        completion?(result)
    }
    
    private(set) var checkInRequests: [(Result<[String: Any], Error>) -> Void] = []
    func checkIn<T>(source: T, completion: @escaping (Result<[String: Any], Error>) -> Void) where T: Checkable {
        messages.append(.checkIn(source))
        checkInRequests.append(completion)
    }
    func simulateCheckInResponse(with result: Result<[String: Any], Error>, at index: Int = 0) {
        let completion = checkInRequests[safe: index]
        completion?(result)
    }
}
