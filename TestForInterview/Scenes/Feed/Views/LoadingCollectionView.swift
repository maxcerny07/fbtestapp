//
//  LoadingCollectionView.swift
//  TestForInterview
//
//  Created by Max Potapov on 25.10.2025.
//

import Foundation
import UIKit

class LoadingCollectionReusableView: UICollectionReusableView {
    private var activityIndicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
    }
}
