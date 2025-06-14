import Foundation
@testable import VSEventsProject

extension Event {
    static func event(
        id: String = "1",
        title: String = "Evento de Teste",
        price: Double = 50.0,
        latitude: Double = -23.550520,
        longitude: Double = -46.633308,
        imageURLString: String = "https://via.placeholder.com/300.png/09f/fff?text=Evento",
        description: String = "Descrição do evento de teste.",
        date: Date = Date(),
        people: [Person] = [.person()],
        cupons: [Cupom] = [.cupom()]
    ) -> Self {
        .init(
            id: id,
            title: title,
            price: price,
            latitude: latitude,
            longitude: longitude,
            image: URL(string: imageURLString)!,
            description: description,
            date: date,
            people: people,
            cupons: cupons
        )
    }

    static func events(count: Int = 3) -> [Self] {
        return (1...count).map { index in
            event(
                id: "\(index)",
                title: "Evento de Teste \(index)",
                people: [.person(id: "p\(index)", eventId: "\(index)")],
                cupons: [.cupom(id: "c\(index)", eventId: "\(index)")]
            )
        }
    }
}

extension Person {
    static func person(
        id: String = "p1",
        eventId: String = "1",
        name: String = "Participante Teste",
        picture: String = "https://via.placeholder.com/50.png/09f/fff?text=P1"
    ) -> Self {
        .init(
            id: id,
            eventId: eventId,
            name: name,
            picture: picture
        )
    }
}

extension Cupom {
    static func cupom(
        id: String = "c1",
        eventId: String = "1",
        discount: Int = 10
    ) -> Self {
        .init(
            id: id,
            eventId: eventId,
            discount: discount
        )
    }
}
