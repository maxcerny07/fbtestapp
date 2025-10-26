//
//  InfoCardView.swift
//  TestForInterview
//
//  Created by Max Potapov on 25.10.2025.
//

import SwiftUI

extension DetailsView {
    struct InfoCardView: View {
        @EnvironmentObject var viewModel: DetailsViewModel
        @Environment(\.presentationMode) var presentationMode
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                
                titleView
                
                contentView
                
                buttonView
                
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 36, style: .continuous)
                    .fill(Color.primaryBackground.opacity(0.85))
            )
        }
    }
}

// MARK: - Views
private extension DetailsView.InfoCardView {
    var titleView: some View {
        HStack {
            Text(viewModel.movie.title)
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
            
            Button {
                withAnimation {
                    viewModel.toggleFavorite(for: viewModel.movie)
                }
            } label: {
                Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.favoriteButton)
                    .frame(width: 24, height: 24)
            }
        }
    }
    
    var contentView: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 8) {
                Text(viewModel.movie.releaseDate)
                Text("• \(viewModel.movie.runtime) min")
            }
            .font(.subheadline)
            .foregroundColor(.gray)
            
            DetailsView.StarRatingView(rating: viewModel.movie.voteAverage, voteCount: viewModel.movie.voteCount)
                .padding(.vertical, 4)
            
            if !viewModel.movie.genres.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.movie.genres) { genre in
                            DetailsView.GenreTagView(genre: genre)
                        }
                    }
                }
            }
        }
    }
    
    var buttonView: some View {
        Button {
            withAnimation { viewModel.showMore.toggle() }
        } label: {
            Image(systemName: "chevron.up")
                .rotationEffect(.degrees(viewModel.showMore ? 180 : 0))
                .foregroundColor(.white.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }
}
