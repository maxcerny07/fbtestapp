//
//  DetailsViewModel.swift
//  TestForInterview
//
//  Created by Sam Titovskyi on 18.08.2025.
//

import Foundation

final class DetailsViewModel: ObservableObject {
    // MARK: - Properties
    enum State {
        case ready
        case error(String)
    }
    
    @Published var state: State = .ready
    @Published var movie: MovieDetailsModel
    @Published var showMore: Bool = false
    @Published var isFavorite: Bool = false
    private let apiClient: APIClientProtocol
    private let favoritesStore: FavoritesStore
    
    // MARK: - Initialization
    
    init(movie: MovieDetailsModel,
         apiClient: APIClientProtocol,
         favoritesStore: FavoritesStore) {
        self.movie = movie
        self.apiClient = apiClient
        self.favoritesStore = favoritesStore
        isFavorite = movie.isFavorite
        fetchMovieDetails()
    }
    
    // MARK: - Public Methods
    
    func fetchMovieDetails() {
        apiClient.fetchMovieDetails(id: movie.id) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                switch result {
                case .success(let details):
                    self.movie = details.toViewModel()
                    self.state = .ready
                case .failure(let error):
                    self.state = .error(error.errorDescription ?? "Something went wrong.")
                }
            }
        }
    }
    
    func toggleFavorite(for movie: MovieDetailsModel) {
        if favoritesStore.isFavorite(id: movie.id) {
            favoritesStore.removeFavorite(id: movie.id)
            isFavorite = false
        } else {
            favoritesStore.addFavorite(movie.toFavoriteMovie())
            isFavorite = true
        }
    }
}

private extension MovieDetailsResponse {
    func toViewModel() -> MovieDetailsModel {
        let isFavorite = DIContainer.shared.favoritesStore.isFavorite(id: self.id)
        return MovieDetailsModel(
            id: self.id,
            title: self.title ?? "",
            overview: self.overview ?? "",
            posterPath: self.posterPath ?? "poster",
            releaseDate: self.releaseDate ?? "",
            voteAverage: self.voteAverage ?? 0.0,
            voteCount: self.voteCount ?? 0.0,
            runtime: self.runtime ?? 0,
            tagline: self.tagline ?? "",
            genres: self.genres ?? [],
            isFavorite: isFavorite)
    }
}

private extension MovieDetailsModel {
    func toFavoriteMovie() -> Self {
        return MovieDetailsModel(
            id: self.id,
            title: self.title,
            overview: self.overview,
            posterPath: self.posterPath,
            releaseDate: self.releaseDate,
            voteAverage: self.voteAverage,
            voteCount: self.voteCount,
            runtime: self.runtime,
            tagline: self.tagline,
            genres: self.genres,
            isFavorite: true)
    }
}
