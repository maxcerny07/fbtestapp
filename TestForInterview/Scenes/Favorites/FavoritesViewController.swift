//
//  FavoritesViewController.swift
//  TestForInterview
//
//  Created by Sam Titovskyi on 18.08.2025.
//

import UIKit
import SwiftUI

class FavoritesViewController: UIViewController {
  
    // MARK: - IBOutlets
    
    @IBOutlet private var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    private var viewModel: FavoritesViewModel
    
    // MARK: - Lifecycle
    
    init(viewModel: FavoritesViewModel, favoritesStore: FavoritesStore) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
        self.viewModel.setupFavoritesObserver()
    }
    
    required init?(coder: NSCoder) {
        let favoritesStore = DIContainer.shared.favoritesStore
        self.viewModel = FavoritesViewModel(favoritesStore: favoritesStore)
        super.init(coder: coder)
        self.viewModel.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupThemeToggleButton()
        setupUI()
        viewModel.setupFavoritesObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavorites()
        collectionView.reloadData()
        collectionView.isHidden = viewModel.movies.isEmpty
    }

    // MARK: - UI Setup
    
    private func setupUI() {
        title = "Favorites"
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width / 2 - 15, height: view.frame.height / 2.5 - 15)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: String(describing: MovieCollectionViewCell.self))
    }
    
    private func updateNavigationBarTitle() {
        title = "Favorites (♡\(viewModel.movies.count))"
    }
}

// MARK: - UICollectionViewDataSource

extension FavoritesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieCollectionViewCell.self), for: indexPath) as? MovieCollectionViewCell else {
            print("Error: Failed to dequeue MovieCollectionViewCell")
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        
        if let movie = viewModel.movie(at: indexPath.item) {
            cell.configure(with: movie)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension FavoritesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movie = viewModel.movie(at: indexPath.item) {
            let apiClient = DIContainer.shared.apiClient
            let favoritesStore = DIContainer.shared.favoritesStore
            let detailsViewModel = DetailsViewModel(movie: movie, apiClient: apiClient, favoritesStore: favoritesStore)
            let controller = UIHostingController(rootView: DetailsView(viewModel: detailsViewModel))
            navigationController?.present(controller, animated: true)
        }
    }
}

// MARK: - MovieCollectionViewCellDelegate

extension FavoritesViewController: MovieCollectionViewCellDelegate {
    func didTapFavorite(for movieId: Int) {
        guard let index = viewModel.movies.firstIndex(where: { $0.id == movieId }) else { return }
        viewModel.removeFavorite(at: index)
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [indexPath])
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.collectionView.layoutIfNeeded()
            }
        })
    }
}

extension FavoritesViewController: FavoritesViewModelDelegate {
    func didFetchMovies() {
        collectionView.reloadData()
    }
}
