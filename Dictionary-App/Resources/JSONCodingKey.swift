//
//  JSONCodingKey.swift
//  Dictionary-App
//
//  Created by Victor Marquez on 26/11/24.
//

import Foundation

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
            return nil
    }

    required init?(stringValue: String) {
            key = stringValue
    }

    var intValue: Int? {
            return nil
    }

    var stringValue: String {
            return key
    }
}

