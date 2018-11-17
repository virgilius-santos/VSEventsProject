//
//  Event.swift
//  VSEventsProject
//
//  Created by Virgilius Santos on 16/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

struct Event: Decodable, Identifiable {
    var id: String
    var title: String
    var price: Double
    var latitude: Double
    var longitude: Double
    var image: URL
    var description: String
    var date: Date
    var people: [Person]
    var cupons: [Cupom]

    enum CodingKeys: String, CodingKey {
        case id, title, price, latitude, longitude
        case image, description, date, people, cupons
    }

}

extension Event {

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
