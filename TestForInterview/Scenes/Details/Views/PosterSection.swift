//
//  PosterSection.swift
//  TestForInterview
//
//  Created by Max Potapov on 25.10.2025.
//

import SwiftUI

extension DetailsView {
    struct PosterSection: View {
        @EnvironmentObject var viewModel: DetailsViewModel
 
        var body: some View {
            ZStack(alignment: .bottom) {
                PosterView(path: viewModel.movie.posterPath)
                    .frame(
                        width: UIScreen.main.bounds.width + 8,
                        height: UIScreen.main.bounds.height - 180
                    )
                    .edgesIgnoringSafeArea(.top)
                    .clipped()
                
                InfoCardView()
                    .environmentObject(viewModel)
                    .padding(.bottom, 0)
            }
            .clipShape(RoundedCornerShape(bottomLeft: 36, bottomRight: 36))
        }
    }
}

extension DetailsView {
    struct PosterView: View {
        let path: String?
        
        var body: some View {
            Group {
                if let path = path,
                   let url = URL(string: "https://image.tmdb.org/t/p/w780\(path)") {
                    AsyncImageView(url: url)
                        .aspectRatio(contentMode: .fill)
                } else {
                    Color.primaryBackground
                }
            }
        }
    }
}
