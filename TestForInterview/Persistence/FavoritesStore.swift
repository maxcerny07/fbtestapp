//
//  FavoritesStore.swift
//  TestForInterview
//
//  Created by Max Potapov on 25.10.2025.
//

import Foundation

protocol FavoritesStore {
    func isFavorite(id: Int) -> Bool
    func addFavorite(_ movie: MovieDetailsModel)
    func removeFavorite(id: Int)
    func allFavorites() -> [MovieDetailsModel]
    func observeFavorites(_ observer: @escaping ([MovieDetailsModel])->Void) -> UUID
    func removeObserver(_ id: UUID)
}

final class DefaultFavoritesStore: FavoritesStore {
    private let favoritesKey = "favorites_movies_v1"
    private let queue = DispatchQueue(label: "favorites.store.queue")
    private var observers: [UUID: ([MovieDetailsModel])->Void] = [:]

    func isFavorite(id: Int) -> Bool {
        return allFavorites().contains { $0.id == id }
    }

    func addFavorite(_ movie: MovieDetailsModel) {
        queue.sync {
            var items = allFavorites()
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
            var items = allFavorites()
            items.removeAll { $0.id == id }
            save(items)
            notify()
            AppLoger.log("Removed \(id) from favorites", type: .persistence)
        }
    }

    func allFavorites() -> [MovieDetailsModel] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey) else { return [] }
        let decoded = try? JSONDecoder().decode([MovieDetailsModel].self, from: data)
        return decoded ?? []
    }

    private func save(_ movies: [MovieDetailsModel]) {
        let data = try? JSONEncoder().encode(movies)
        UserDefaults.standard.set(data, forKey: favoritesKey)
    }

    func observeFavorites(_ observer: @escaping ([MovieDetailsModel]) -> Void) -> UUID {
        let id = UUID()
        queue.sync {
            observers[id] = observer
        }
        observer(allFavorites())
        return id
    }

    func removeObserver(_ id: UUID) {
        queue.sync { observers.removeValue(forKey: id) }
        print("🩷 Removed observer")
    }

    private func notify() {
        let items = allFavorites()
        for obs in observers.values { obs(items) }
    }
}
