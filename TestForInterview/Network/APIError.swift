//
//  APIError.swift
//  TestForInterview
//
//  Created by Max Potapov on 25.10.2025.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(DecodingError)
    case networkError(Error)
    case httpError(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .noData: return "No data received"
        case .decodingError(let error): return "Failed to decode data: \(error.localizedDescription)"
        case .networkError(let error): return "Network error: \(error.localizedDescription)"
        case .httpError(let statusCode): return "HTTP error with status code: \(statusCode)"
        }
    }
}
