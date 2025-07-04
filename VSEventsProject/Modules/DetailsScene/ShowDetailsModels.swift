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
    var imageUrl: URL {
        image
    }
    
    var dateString: String {
        date.toString()
    }
    
    var priceValue: String {
        "\(price)"
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
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

protocol PersonCellViewModel {
    var eventItem: Person { get }
    var title: String { get }
    var imageUrl: URL? { get }
}

extension Person: PersonCellViewModel {
    var title: String {
        self.name
    }

    var imageUrl: URL? {
        URL(string: self.picture)
    }

    var eventItem: Person {
        self
    }
}
