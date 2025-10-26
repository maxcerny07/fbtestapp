//
//  FavoritesViewModel.swift
//  TestForInterview
//
//  Created by Sam Titovskyi on 18.08.2025.
//

import Foundation

protocol FavoritesViewModelDelegate: AnyObject {
    func didFetchMovies()
}

class FavoritesViewModel {
    
    // MARK: - Properties
    
    weak var delegate: FavoritesViewModelDelegate?
    
    private(set) var movies: [MovieDetailsModel] = []
    private let favoritesStore: FavoritesStore
    
    private var favoritesObserverId: UUID?

    // MARK: - Initialization
    
    init(favoritesStore: FavoritesStore) {
        self.favoritesStore = favoritesStore
        loadFavorites()
    }
    
    func setupFavoritesObserver() {
        self.favoritesObserverId = favoritesStore.observeFavorites { [weak self] _ in
            DispatchQueue.main.async {
                self?.refreshMoviesFavoriteStatus()
                self?.delegate?.didFetchMovies()
            }
        }
    }
    
    deinit {
        if let id = favoritesObserverId {
            favoritesStore.removeObserver(id)
        }
    }
    
    // MARK: - Public Methods
    
    func loadFavorites() {
        movies = favoritesStore.allFavorites()
    }
    
    func movie(at index: Int) -> MovieDetailsModel? {
        guard index < movies.count else { return nil }
        return movies[index]
    }
    
    func removeFavorite(at index: Int) {
        guard index < movies.count else { return }
        let movie = movies[index]
        movies.remove(at: index)
        favoritesStore.removeFavorite(id: movie.id)
    }
    
    // MARK: - Private Methods
    
    private func refreshMoviesFavoriteStatus() {
        for index in movies.indices {
            let isFavorite = favoritesStore.isFavorite(id: movies[index].id)
            if movies[index].isFavorite != isFavorite {
                let updatedMovie = MovieDetailsModel(
                    id: movies[index].id,
                    title: movies[index].title,
                    overview: movies[index].overview,
                    posterPath: movies[index].posterPath,
                    releaseDate: movies[index].releaseDate,
                    voteAverage: movies[index].voteAverage,
                    voteCount: movies[index].voteCount,
                    runtime: movies[index].runtime,
                    tagline: movies[index].tagline,
                    genres: movies[index].genres,
                    isFavorite: isFavorite
                )
                movies[index] = updatedMovie
            }
        }
    }
}