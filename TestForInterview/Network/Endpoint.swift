//
//  Endpoint.swift
//  TestForInterview
//
//  Created by Max Potapov on 25.10.2025.
//

import Foundation

enum Endpoint {
    case topRated(page: Int)
    case movieDetails(id: Int)
    case search(query: String, page: Int)

    var path: String {
        switch self {
        case .topRated: return "/movie/top_rated"
        case .movieDetails(let id): return "/movie/\(id)"
        case .search: return "/search/movie"
        }
    }

    var queryItems: [URLQueryItem] {
        var items: [URLQueryItem] = [URLQueryItem(name: "language", value: "en-US")]
        switch self {
        case .topRated(let page):
            items.append(URLQueryItem(name: "page", value: "\(page)"))
        case .search(let query, let page):
            items.append(URLQueryItem(name: "query", value: query))
            items.append(URLQueryItem(name: "page", value: "\(page)"))
            items.append(URLQueryItem(name: "include_adult", value: "false"))
        case .movieDetails: break
        }
        return items
    }
}
