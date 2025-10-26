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

struct MovieDetailsResponse: Codable, Equatable {
    let id: Int
    let title: String?
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double?
    let voteCount: Double?
    let runtime: Int?
    let tagline: String?
    let genres: [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case runtime
        case tagline
        case genres
    }
    
    init(id: Int,
         title: String?,
         overview: String?,
         posterPath: String?,
         releaseDate: String?,
         voteAverage: Double?,
         voteCount: Double? = nil,
         runtime: Int? = nil,
         tagline: String? = nil,
         genres: [Genre]? = nil)
    {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.runtime = runtime
        self.tagline = tagline
        self.genres = genres
    }
}

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
