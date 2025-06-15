import Foundation
@testable import VSEventsProject

final class ShowDetailsPresentationLogicMock: ShowDetailsPresentationLogic {
    enum Message: Equatable {
        case presentDetail(_ result: Result<Event, SingleButtonAlert>)
        case presentCheckIn(_ buttonAlert: SingleButtonAlert)
    }
    
    private(set) var messages: [Message] = [] {
        didSet {
            anyMessages.appendLast(of: messages)
        }
    }
    
    var anyMessages = AnyMessage()
    
    func presentDetail(_ result: Result<Event, SingleButtonAlert>) {
        messages.append(.presentDetail(result))
    }
    
    func presentCheckIn(_ buttonAlert: SingleButtonAlert) {
        messages.append(.presentCheckIn(buttonAlert))
    }
}
