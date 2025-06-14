import Foundation
@testable import VSEventsProject

final class ShowEventsPresentationLogicMock: ShowEventsPresentationLogic {
    var resultReceived: [Result<[Event], SingleButtonAlert>] = []
    func displayEvents(result: Result<[Event], SingleButtonAlert>) {
        resultReceived.append(result)
    }
}
