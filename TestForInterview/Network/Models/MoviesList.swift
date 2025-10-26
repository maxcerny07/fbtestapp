//
//  MoviesList.swift
//  TestForInterview
//
//  Created by Max Potapov on 25.10.2025.
//

import Foundation

struct MovieListResponse: Codable {
    let page: Int
    let results: [MovieDetailsResponse]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
