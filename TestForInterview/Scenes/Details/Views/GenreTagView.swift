//
//  GenreTagView.swift
//  TestForInterview
//
//  Created by Max Potapov on 25.10.2025.
//

import SwiftUI

extension DetailsView {
    struct GenreTagView: View {
        let genre: Genre
        
        var body: some View {
            Text(genre.name)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .background(Color.white.opacity(0.1))
                .clipShape(Capsule())
        }
    }
}
