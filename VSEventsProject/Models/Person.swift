//
//  Person.swift
//  VSEventsProject
//
//  Created by Virgilius Santos on 16/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

struct Person: Decodable, Identifiable {
    var id: String
    var eventId: String
    var name: String
    var picture: String
}
