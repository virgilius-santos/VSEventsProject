import Foundation
@testable import VSEventsProject

final class ShowEventsRoutingLogicMock: ShowEventsRoutingLogic {
    enum Message: Equatable {
        case routeToDetail(Event)
    }
    
    private(set) var messages: [Message] = [] {
        didSet {
            anyMessages.appendLast(of: messages)
        }
    }
    
    var anyMessages = AnyMessage()
    
    func routeToDetail(_ eventItem: Event) {
        messages.append(.routeToDetail(eventItem))
    }
}
