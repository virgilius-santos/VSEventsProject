import Foundation
import MapKit

struct EventDetailInfo: DetailInfo {
    
    var imageUrl: URL
    
    let event: Event

    var title: String { event.title }
    var image: URL? { event.image }
    var priceValue: String { String(format: "R$ %.2f", event.price) }
    var region: MKCoordinateRegion {
        MKCoordinateRegion(
            center: event.coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
    }
    var coordinate: CLLocationCoordinate2D { event.coordinate }

    var annotations: [MKAnnotation] {
        let anot = MKPointAnnotation()
        anot.coordinate = event.coordinate
        return [anot]
    }

    var description: String { event.description }
    var dateString: String { event.date.toString() }
    var people: [Person] { event.people }
    var cupons: [Cupom] { event.cupons }
}
