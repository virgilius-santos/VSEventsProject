import Foundation
import RxSwift
import RxCocoa

struct MockPersonCellViewModel: PersonCellViewModel {
    var eventItem: Person
    let title: String
    let imageUrl: URL?
}
