//
//  Codable.swift
//  VSEventsProject
//
//  Created by Virgilius Santos on 20/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

extension Encodable {
    func toData() throws -> Data {
        try JSONEncoder().encode(self)
    }
}

extension Decodable {
    static func decoder(json: Data) throws -> Self {
        try JSONDecoder().decode(Self.self, from: json)
    }
}

extension Data {
    func toJson() throws -> [String: Any] {
        try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any] ?? [:]
    }
}
