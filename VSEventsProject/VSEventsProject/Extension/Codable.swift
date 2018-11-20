//
//  Codable.swift
//  VSEventsProject
//
//  Created by Virgilius Santos on 20/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

extension Encodable {
    func toJson(excluding keys: [String] = [String]()) throws -> [String: Any] {

        let objectData = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: objectData, options: [])

        var json = jsonObject as! [String: Any]

        keys.forEach { json[$0] = nil }

        return json
    }
}

extension Decodable {
    static func decoder(json: Any) throws -> Self {

        let documentData = try JSONSerialization.data(withJSONObject: json, options: [])
        let decodeObject = try JSONDecoder().decode(Self.self, from: documentData)

        return decodeObject
    }
}
