import UIKit
import RxSwift
import RxCocoa
import MapKit

protocol DetailInfo {
    var title: String { get }
    var imageUrl: URL { get }
    var priceValue: String { get }
    var region: MKCoordinateRegion { get }
    var coordinate: CLLocationCoordinate2D { get }
    var annotations: [MKAnnotation] { get }
    var description: String { get }
    var dateString: String { get }
    var people: [Person] { get }
    var cupons: [Cupom] { get }
}

extension Event: DetailInfo {
    var dateString: String {
        return date.toString()
    }
    
    var priceValue: String {
        "\(price)"
    }

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var region: MKCoordinateRegion {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: regionRadius * 2.0,
            longitudinalMeters: regionRadius * 2.0
        )
        return coordinateRegion
    }

    var annotations: [MKAnnotation] {
        let anot = MKPointAnnotation()
        anot.coordinate = coordinate
        return [anot]
    }
}

final class DetailViewModel {

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

protocol PersonCellViewModel {
    var eventItem: Person { get }
    var title: String { get }
    var imageUrl: URL? { get }
}

extension Person: PersonCellViewModel {
    var title: String {
        return self.name
    }

    var imageUrl: URL? {
        return URL(string: self.picture)
    }

    var eventItem: Person {
        return self
    }
}
