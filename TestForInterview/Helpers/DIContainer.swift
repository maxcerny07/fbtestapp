//
//  DIContainer.swift
//  TestForInterview
//
//  Created by Max Potapov on 26.10.2025.
//

import Foundation

class DIContainer {
   static let shared = DIContainer()
   
   private init() {}
   
   // MARK: - Dependencies
   private var _favoritesStore: FavoritesStoreProtocol?
   private var _apiClient: APIClientProtocol?
   
   // MARK: - Computed Properties
   var favoritesStore: FavoritesStoreProtocol {
       if _favoritesStore == nil {
           _favoritesStore = DefaultFavoritesStore()
       }
       return _favoritesStore!
   }
   
   var apiClient: APIClientProtocol {
       if _apiClient == nil {
           _apiClient = APIClient()
       }
       return _apiClient!
   }
}
