//
//  String.swift
//  VSEventsProject
//
//  Created by Virgilius Santos on 20/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

enum Patterns: String {
    case email
        = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$"
}

extension String {
    func match(_ pattern: Patterns) -> Bool {
        let mutable = NSMutableString(string: self)
        let range: NSRange = NSRange(location: 0, length: self.count)
        do {
            let regex = try NSRegularExpression(pattern: pattern.rawValue)
            regex.replaceMatches(in: mutable, range: range, withTemplate: "")
        } catch {
            return false
        }
        return String(mutable).isEmpty
    }
}


