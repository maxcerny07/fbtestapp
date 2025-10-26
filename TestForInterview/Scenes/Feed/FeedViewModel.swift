//
//  FeedViewModel.swift
//  TestForInterview
//
//  Created by Sam Titovskyi on 18.08.2025.
//

import Foundation

protocol FeedViewModelDelegate: AnyObject {
    func didFetchMovies()
    func didUpdateAverageRating(_ rating: String)
    func didShowAlert(title: String, message: String)
}

final class FeedViewModel: ObservableObject {
    
    // MARK: - Properties
    
    weak var delegate: FeedViewModelDelegate?
    
    private let apiClient: APIClientProtocol
    private let favoritesStore: FavoritesStore
    private let debouncer = Debouncer(interval: 0.5)
    
    private var favoritesObserverId: UUID?
    
    private(set) var movies: [MovieDetailsModel] = []
    private var currentPage = 1
    private var totalPages = 1
    private var isLoading = false
    private let paginationThreshold = 4
    
    enum FeedState {
        case topRated
        case searching(query: String)
    }
    
    private var currentState: FeedState = .topRated
    
    // MARK: - Init / Deinit
    
    init(apiClient: APIClientProtocol,
         favoritesStore: FavoritesStore) {
        self.apiClient = apiClient
        self.favoritesStore = favoritesStore
        
        self.favoritesObserverId = favoritesStore.observeFavorites { [weak self] _ in
            DispatchQueue.main.async {
                self?.refreshMoviesFavoriteStatus()
                self?.delegate?.didFetchMovies()
                self?.notifyAverageRatingUpdate()
            }
        }
    }
    
    deinit {
        if let id = favoritesObserverId {
            favoritesStore.removeObserver(id)
        }
    }
    
    // MARK: - Public Methods
    
    func searchMovies(query: String) {
        guard !query.isEmpty else {
            fetchMovies(reset: true)
            return
        }
        
        currentState = .searching(query: query)
        
        debouncer.call { [weak self] in
            guard let self = self else { return }
            self.apiClient.searchMovies(query: query, page: 1) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        if case .searching(let currentQuery) = self.currentState, currentQuery == query {
                            self.movies = response.results.map { $0.toViewModel() }
                            self.delegate?.didFetchMovies()
                            self.notifyAverageRatingUpdate()
                        }
                    case .failure(let error):
                        self.delegate?.didShowAlert(title: "Oops", message: error.errorDescription ?? "Something went wrong")
                    }
                }
            }
        }
    }
    
    func fetchMovies(reset: Bool = false) {
        currentState = .topRated
        
        guard !isLoading else { return }
        isLoading = true
        
        let page = reset ? 1 : currentPage
        
        apiClient.fetchTopRatedMovies(page: page) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let response):
                    self.totalPages = response.totalPages
                    
                    if reset {
                        self.movies = response.results.map { $0.toViewModel() }
                        self.currentPage = 1
                    } else {
                        self.movies.append(contentsOf: response.results.map { $0.toViewModel() })
                        self.currentPage += 1
                    }
                    
                    self.delegate?.didFetchMovies()
                    self.notifyAverageRatingUpdate()
                    
                case .failure(let error):
                    self.delegate?.didShowAlert(title: "Oops", message: error.errorDescription ?? "Something went wrong")
                }
            }
        }
    }
    
    func loadMoreMoviesIfNeeded(currentIndex: Int) {
        let itemsRemaining = movies.count - currentIndex
        
        if itemsRemaining <= paginationThreshold,
           currentPage < totalPages,
           !isLoading {
            fetchMovies()
        }
    }
    
    func movie(at index: Int) -> MovieDetailsModel? {
        guard index < movies.count else { return nil }
        return movies[index]
    }
    
    func toggleFavorite(for movie: MovieDetailsModel) {
        if favoritesStore.isFavorite(id: movie.id) {
            favoritesStore.removeFavorite(id: movie.id)
        } else {
            favoritesStore.addFavorite(movie.toFavoriteMovie())
        }
    }

    // MARK: - Private Methods
    
    private func calculateAverageRating() -> String {
        guard !movies.isEmpty else { return "0.00" }
        let total = movies.compactMap { $0.voteAverage }.reduce(0, +)
        let average = total / Double(movies.count)
        return String(format: "%.2f", average)
    }
    
    private func notifyAverageRatingUpdate() {
        let averageRating = calculateAverageRating()
        delegate?.didUpdateAverageRating(averageRating)
    }
    
    private func refreshMoviesFavoriteStatus() {
        for index in movies.indices {
            let isFavorite = favoritesStore.isFavorite(id: movies[index].id)
            if movies[index].isFavorite != isFavorite {
                var updatedMovie = movies[index]
                updatedMovie.isFavorite = isFavorite
                movies[index] = updatedMovie
            }
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
