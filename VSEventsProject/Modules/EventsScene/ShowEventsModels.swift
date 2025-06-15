import Foundation
import RxSwift
import RxCocoa

struct EventCellViewModel: Equatable {
    let eventItem: Event
    let title: String
    let imageUrl: URL
}

extension EventCellViewModel {
    init(_ event: Event) {
        eventItem = event
        title = event.title
        imageUrl = event.image
    }
}
