//
//  Genre.swift
//  TestForInterview
//
//  Created by Max Potapov on 26.10.2025.
//

import Foundation

struct Genre: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    static func mock(id: Int = 18, name: String = "Drama") -> Genre {
        return Genre(id: id, name: name)
    }
}
