//
//  AsyncImageView.swift
//  TestForInterview
//
//  Created by Max Potapov on 26.10.2025.
//

import SwiftUI
import SDWebImage

extension DetailsView {
    struct AsyncImageView: UIViewRepresentable {
        let url: URL?
        
        func makeUIView(context: Context) -> UIImageView {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            return imageView
        }
        
        func updateUIView(_ uiView: UIImageView, context: Context) {
            uiView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "poster"))
        }
    }
}
