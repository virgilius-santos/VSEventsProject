import Foundation
@testable import VSEventsProject

final class ShowEventsPresentationLogicMock: ShowEventsPresentationLogic {
    enum Message: Equatable {
        case displayEvents(Result<[Event], SingleButtonAlert>)
    }
    
    private(set) var messages: [Message] = [] {
        didSet {
            anyMessages.appendLast(of: messages)
        }
    }
    
    var anyMessages = AnyMessage()
    
    func displayEvents(result: Result<[Event], SingleButtonAlert>) {
        messages.append(.displayEvents(result))
    }
}
