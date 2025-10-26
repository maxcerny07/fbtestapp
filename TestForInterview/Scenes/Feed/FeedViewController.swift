//
//  FeedViewController.swift
//  TestForInterview
//
//  Created by Sam Titovskyi on 18.08.2025.
//

import UIKit
import SwiftUI

class FeedViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    
    private var viewModel: FeedViewModel
    private var refreshControl: UIRefreshControl!
    private var activityIndicator: UIActivityIndicatorView!
    private var isFirstLoad = true
    private var loadingMoreView: LoadingCollectionReusableView?
    
    // MARK: - Lifecycle
    
    init(viewModel: FeedViewModel,
         apiClient: APIClient,
         favoritesStore: FavoritesStoreProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        let apiClient = DIContainer.shared.apiClient
        let favoritesStore = DIContainer.shared.favoritesStore
        self.viewModel = FeedViewModel(apiClient: apiClient, favoritesStore: favoritesStore)
        super.init(coder: coder)
        self.viewModel.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupUI()
        setupThemeToggleButton()
        self.hideKeyboardWhenTappedAround()
        viewModel.fetchMovies()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        configureCollectionView()
        setupRefreshControl()
        setupActivityIndicator()
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.frame.width / 2 - 15, height: view.frame.height / 2.5 - 15)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: String(describing: MovieCollectionViewCell.self))
        
        collectionView.register(LoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: "LoadingFooter")
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search for movies..."
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .systemBlue
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func updateNavigationBarTitle(with rating: String) {
        title = "Top Rated (⟡\(rating))"
    }
    
    @objc private func refreshData() {
        viewModel.fetchMovies(reset: true)
    }
}

// MARK: - FeedViewModelDelegate

extension FeedViewController: FeedViewModelDelegate {
    func didShowAlert(title: String, message: String) {
        showAlertWith(title: title, message: message, firstButtonTitle: "Ok")
    }
    
    func didUpdateAverageRating(_ rating: String) {
        updateNavigationBarTitle(with: rating)
    }
    
    func didFetchMovies() {
        collectionView.reloadData()
        
        // Stop refreshing when data is loaded
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        
        // Hide activity indicator after first load
        if isFirstLoad {
            activityIndicator.stopAnimating()
            isFirstLoad = false
        }
    }
}

// MARK: - UICollectionViewDataSource

extension FeedViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFirstLoad && viewModel.movies.isEmpty {
            activityIndicator.startAnimating()
        }
        
        return viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieCollectionViewCell.self), for: indexPath) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        
        if let movie = viewModel.movie(at: indexPath.item) {
            cell.configure(with: movie)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadingFooter", for: indexPath) as! LoadingCollectionReusableView
            loadingMoreView = footer
            return footer
        }
        return UICollectionReusableView()
    }
}

// MARK: - UICollectionViewDelegate

extension FeedViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movie = viewModel.movie(at: indexPath.item) {
            let apiClient = DIContainer.shared.apiClient
            let favoritesStore = DIContainer.shared.favoritesStore
            let detailsViewModel = DetailsViewModel(movie: movie, apiClient: apiClient, favoritesStore: favoritesStore)
            let controller = UIHostingController(rootView: DetailsView(viewModel: detailsViewModel))
            navigationController?.present(controller, animated: true)
        }
    }
    

    
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            if let loadingView = view as? LoadingCollectionReusableView {
                loadingView.startAnimating()
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return viewModel.movies.count > 0 ? CGSize(width: collectionView.frame.width, height: 50) : .zero
    }
}

// MARK: - UISearchBarDelegate
extension FeedViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchMovies(query: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.fetchMovies()
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension FeedViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let lastItemIndexPath = indexPaths.last else { return }
        if lastItemIndexPath.row >= viewModel.movies.count - 10 {
            viewModel.loadMoreMoviesIfNeeded(currentIndex: lastItemIndexPath.row)
        }
    }
}

// MARK: - MovieCollectionViewCellDelegate

extension FeedViewController: MovieCollectionViewCellDelegate {
    func didTapFavorite(for movieId: Int) {
        if let movie = viewModel.movies.first(where: { $0.id == movieId }) {
            viewModel.toggleFavorite(for: movie)
            collectionView.reloadData()
        }
    }
}
