//
//  DefaultFavoritesStore.swift
//  TestForInterview
//
//  Created by Max Potapov on 26.10.2025.
//

import Foundation

/// A default implementation of the favorites store using UserDefaults for persistence.
/// Manages storage and retrieval of favorite movies with thread-safe operations and observer support.
final class DefaultFavoritesStore {
    private let favoritesKey = "favorites_movies_v1"
    private let queue = DispatchQueue(label: "favorites.store.queue")
    private var observers: [UUID: ([MovieDetailsModel])->Void] = [:]
}

// MARK: - FavoritesStoreProtocol

extension DefaultFavoritesStore: FavoritesStoreProtocol {
    func isFavorite(id: Int) -> Bool {
        return fetchFavoriteMovies().contains { $0.id == id }
    }

    func addFavorite(_ movie: MovieDetailsModel) {
        queue.sync {
            var items = fetchFavoriteMovies()
            if !items.contains(where: { $0.id == movie.id }) {
                items.append(movie)
                save(items)
                notify()
                AppLoger.log("Stored \(movie.title) with id \(movie.id) to favorites", type: .persistence)
            }
        }
    }

    func removeFavorite(id: Int) {
        queue.sync {
            var items = fetchFavoriteMovies()
            items.removeAll { $0.id == id }
            save(items)
            notify()
            AppLoger.log("Removed \(id) from favorites", type: .persistence)
        }
    }

    func fetchFavoriteMovies() -> [MovieDetailsModel] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey) else { return [] }
        let decoded = try? JSONDecoder().decode([MovieDetailsModel].self, from: data)
        return decoded ?? []
    }



    func startObserving(_ observer: @escaping ([MovieDetailsModel]) -> Void) -> UUID {
        let id = UUID()
        queue.sync {
            observers[id] = observer
        }
        observer(fetchFavoriteMovies())
        return id
    }

    func removeObserver(_ id: UUID) {
        queue.sync { observers.removeValue(forKey: id) }
        AppLoger.log("Observer removed", type: .persistence)
    }
}

// MARK: - Private Methods

private extension DefaultFavoritesStore {
    func save(_ movies: [MovieDetailsModel]) {
        let data = try? JSONEncoder().encode(movies)
        UserDefaults.standard.set(data, forKey: favoritesKey)
    }
    
    func notify() {
        let items = fetchFavoriteMovies()
        for obs in observers.values { obs(items) }
    }
}
