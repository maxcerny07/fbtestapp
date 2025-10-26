//
//  MovieDetailsViewModel.swift
//  TestForInterview
//
//  Created by Max Potapov on 26.10.2025.
//

struct MovieDetailsModel: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Double
    let runtime: Int
    let tagline: String
    let genres: [Genre]
    var isFavorite: Bool
    
    static func mock(id: Int = 550,
                    title: String? = "Fight Club",
                    overview: String? = "A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy. Their concept catches on, with underground \"fight clubs\" forming in every town, until an eccentric gets in the way and ignites an out-of-control spiral toward oblivion.",
                    posterPath: String? = "/pB8BM7pdSp6B6Ih7QZ4DrQ3PmJK.jpg",
                    releaseDate: String? = "1999-10-15",
                    voteAverage: Double? = 8.433,
                    voteCount: Double? = 25000.0,
                    runtime: Int? = 139,
                    tagline: String? = "Mischief. Mayhem. Soap.",
                    genres: [Genre]? = [Genre(id: 18, name: "Drama"), Genre(id: 53, name: "Thriller")]) -> MovieDetailsModel {
        return MovieDetailsModel(
            id: id,
            title: title ?? "",
            overview: overview ?? "",
            posterPath: posterPath ?? "",
            releaseDate: releaseDate ?? "",
            voteAverage: voteAverage ?? 0,
            voteCount: voteCount ?? 0.0,
            runtime: runtime ?? 0,
            tagline: tagline ?? "",
            genres: genres ?? [],
            isFavorite: false
        )
    }
}


