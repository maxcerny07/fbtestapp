//
//  DetailsView.swift
//  TestForInterview
//
//  Created by Sam Titovskyi on 18.08.2025.
//

import SwiftUI

struct DetailsView: View {
    @ObservedObject private var viewModel: DetailsViewModel
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color.secondaryBackground
                .edgesIgnoringSafeArea(.all)
            
            switch viewModel.state {
            case .ready:
                content
            case .error(let error):
                Text("Oops, \(error)")
                    .font(.headline)
                    .foregroundColor(.primaryBackground)
            }
        }
    }
}

// MARK: - Views

private extension DetailsView {
    var content: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                PosterSection()
                .environmentObject(viewModel)
                
                if viewModel.showMore {
                    createOverviewSection()
                }
                
                createShowMoreButton()
            }
        }
    }
        
    func createOverviewSection() -> some View {
        Text(viewModel.movie.overview)
            .font(.body)
            .foregroundColor(.primaryBackground)
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .transition(.opacity.combined(with: .move(edge: .top)))
    }
    
    func createShowMoreButton() -> some View {
        Button(action: {
            withAnimation { viewModel.showMore.toggle() }
        }){
            VStack(spacing: 0) {
                Text(viewModel.showMore ? "tap to" : "tap for")
                    .fontWeight(.light)
                    .foregroundColor(.primaryBackground)
                    .frame(maxWidth: .infinity)
        
                Text(viewModel.showMore ? "HIDE DETAILS" : "MORE DETAILS")
                    .fontWeight(.semibold)
                    .foregroundColor(.primaryBackground)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
        }
    }
}


// MARK: - Preview

#Preview {
    let viewModel = DetailsViewModel(movie: MovieDetailsModel.mock(),
                                     apiClient: DIContainer.shared.apiClient,
                                     favoritesStore: DIContainer.shared.favoritesStore)
    DetailsView(viewModel: viewModel)
}
