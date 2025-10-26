//
//  FavoritesStore.swift
//  TestForInterview
//
//  Created by Max Potapov on 25.10.2025.
//

import Foundation

protocol FavoritesStoreProtocol {
    /// Checks if a movie with the specified ID is marked as favorite.
    /// - Parameter id: The unique identifier of the movie to check.
    /// - Returns: `true` if the movie is in the favorites list, `false` otherwise.
    func isFavorite(id: Int) -> Bool
    
    /// Adds a movie to the favorites list.
    /// - Parameter movie: The movie to add to favorites.
    /// If the movie is already in favorites, no action is taken.
    func addFavorite(_ movie: MovieDetailsModel)
    
    /// Removes a movie from the favorites list by its ID.
    /// - Parameter id: The unique identifier of the movie to remove.
    func removeFavorite(id: Int)
    
    /// Retrieves all movies currently marked as favorites.
    /// - Returns: An array of `MovieDetailsModel` objects representing favorite movies.
    func fetchFavoriteMovies() -> [MovieDetailsModel]
    
    /// Registers an observer to be notified when the favorites list changes.
    /// - Parameter observer: A closure that will be called with the updated favorites list whenever it changes.
    /// - Returns: A unique identifier that can be used to remove the observer later.
    func startObserving(_ observer: @escaping ([MovieDetailsModel])->Void) -> UUID
    
    /// Removes an observer so it will no longer be notified of favorites changes.
    /// - Parameter id: The unique identifier of the observer to remove.
    func removeObserver(_ id: UUID)
}
