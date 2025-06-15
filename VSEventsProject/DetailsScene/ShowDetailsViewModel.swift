import Foundation
import RxSwift
import RxCocoa

final class ShowDetailsViewModel {

    var eventDetail: Observable<DetailInfo> {
        return event.asObservable()
    }
    let event = PublishRelay<DetailInfo>()

    var eventCells: Observable<[PersonCellViewModel]> {
        return cells.asObservable()
    }
    let cells = BehaviorRelay<[PersonCellViewModel]>(value: [])

    let onShowError = PublishSubject<SingleButtonAlert>()
    
    let disposeBag = DisposeBag()

    init() {
        eventDetail
            .map(\.people)
            .bind(to: cells)
            .disposed(by: disposeBag)
    }
    
}
