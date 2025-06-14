import Foundation

struct Event: Decodable, Identifiable, Equatable {
    let id: String
    let title: String
    let price: Double
    let latitude: Double
    let longitude: Double
    let image: URL
    let description: String
    let date: Date
    let people: [Person]
    let cupons: [Cupom]
}

extension Event {
    enum CodingKeys: String, CodingKey {
        case id, title, price, latitude, longitude
        case image, description, date, people, cupons
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        price = try container.decode(Double.self, forKey: .price)

        if let latitude = try? container.decode(String.self, forKey: .latitude) {
            self.latitude = Double(latitude) ?? 0
        } else {
            latitude = try container.decode(Double.self, forKey: .latitude)
        }

        if let longitude = try? container.decode(String.self, forKey: .longitude) {
            self.longitude = Double(longitude) ?? 0
        } else {
            longitude = try container.decode(Double.self, forKey: .longitude)
        }

        image = try container.decode(URL.self, forKey: .image)
        description = try container.decode(String.self, forKey: .description)

        let timeInterval = try container.decode(TimeInterval.self, forKey: .date)
        date = Date(timeIntervalSince1970: timeInterval)

        people = try container.decode([Person].self, forKey: .people)
        cupons = try container.decode([Cupom].self, forKey: .cupons)
    }
}
