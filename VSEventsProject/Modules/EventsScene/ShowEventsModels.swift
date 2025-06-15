import Foundation
import RxSwift
import RxCocoa

protocol EventCellViewModel {
    var eventItem: Event { get }
    var title: String { get }
    var imageUrl: URL { get }
}

extension Event: EventCellViewModel {
    var imageUrl: URL {
        return image
    }

    var eventItem: Event {
        return self
    }
}
