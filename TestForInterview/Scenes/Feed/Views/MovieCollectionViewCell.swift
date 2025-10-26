//
//  MovieCollectionViewCell.swift
//  TestForInterview
//
//  Created by Max Potapov on 25.10.2025.
//

import UIKit
import SDWebImage

protocol MovieCollectionViewCellDelegate: AnyObject {
    func didTapFavorite(for movieId: Int)
}

class MovieCollectionViewCell: UICollectionViewCell {
    
    private var movieId: Int?
    weak var delegate: MovieCollectionViewCellDelegate?
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    

    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        titleLabel.text = nil
        ratingLabel.text = nil
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
    
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
    }
    
    // MARK: - Configuration
    
    func configure(with viewModel: MovieDetailsModel) {
        self.movieId = viewModel.id
        favoriteButton.isSelected = viewModel.isFavorite
        titleLabel.text = viewModel.title
        releaseDateLabel.text = "(\(viewModel.releaseDate.toYear() ?? ""))"
        ratingLabel.text = "IMDB \(String(format: "%.1f", viewModel.voteAverage))"
        let imageURL = URL(string: "https://image.tmdb.org/t/p/w500\(viewModel.posterPath)")
        posterImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(systemName: "photo"))
    }
    
    // MARK: - Actions
    
    @IBAction private func favoriteButtonTapped(_ sender: UIButton) {
        sender.showAnimation { [weak self] in
            sender.isSelected.toggle()
            guard let movieId = self?.movieId else { return }
            self?.delegate?.didTapFavorite(for: movieId)
        }
    }
}


public extension UIView {
    func showAnimation(_ completionBlock: @escaping () -> Void) {
      isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveLinear,
                       animations: { [weak self] in
                            self?.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
        }) {  (done) in
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveLinear,
                           animations: { [weak self] in
                                self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }) { [weak self] (_) in
                self?.isUserInteractionEnabled = true
                completionBlock()
            }
        }
    }
}





