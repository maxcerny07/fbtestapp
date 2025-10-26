//
//  MovieDetailsResponse.swift
//  TestForInterview
//
//  Created by Max Potapov on 26.10.2025.
//

import Foundation

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
