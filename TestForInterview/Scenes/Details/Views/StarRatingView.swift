//
//  StarRatingView.swift
//  TestForInterview
//
//  Created by Max Potapov on 25.10.2025.
//

import SwiftUI

extension DetailsView {
    struct StarRatingView: View {
        let rating: Double?
        let voteCount: Double?
        
        var body: some View {
            contentView
        }
    }
}

// MARK: - Views

private extension DetailsView.StarRatingView {
    var contentView: some View {
        HStack(spacing: 8) {
            HStack(spacing: 2) {
                ForEach(0..<5) { index in
                    Image(systemName: imageName(for: index))
                        .foregroundColor(.startRatingColot)
                }
            }
            
            Text("by \(voteCount.asFormattedString) votes")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

// MARK: - Private Methods

private extension DetailsView.StarRatingView {
    private func imageName(for index: Int) -> String {
        let starValue = (rating ?? 0) - Double(index)
        if starValue >= 1 {
            return "star.fill"
        } else if starValue >= 0.5 {
            return "star.leadinghalf.fill"
        } else {
            return "star"
        }
    }
}

