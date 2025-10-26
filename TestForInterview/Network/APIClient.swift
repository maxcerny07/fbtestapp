//
//  DetailsViewModel.swift
//  TestForInterview
//
//  Created by Sam Titovskyi on 18.08.2025.
//

import Foundation

// MARK: - API Client Protocol

protocol APIClientProtocol {
    func fetchTopRatedMovies(page: Int, completion: @escaping (Result<MovieListResponse, APIError>) -> Void)
    func fetchMovieDetails(id: Int, completion: @escaping (Result<MovieDetailsResponse, APIError>) -> Void)
    func searchMovies(query: String, page: Int, completion: @escaping (Result<MovieListResponse, APIError>) -> Void)
}

// MARK: - API Client

final class APIClient: APIClientProtocol {
    
    enum RequestType: String {
        case get = "GET"
    }

    private let baseURL = "https://api.themoviedb.org"
    private var apiVersion: String?
    private let session: URLSession
    private var bearerToken: String?

    init(session: URLSession = .shared) {
        self.session = session
        configure()
    }

    // MARK: - Configure Bearer Token

    private func configure(bearerToken: String = AppConfig.bearerToken, apiVersion: String = AppConfig.apiVersion) {
        self.bearerToken = bearerToken
        self.apiVersion = apiVersion
        AppLoger.log("Bearer token configured", type: .network)
    }

    // MARK: - Public Methods

    func fetchTopRatedMovies(page: Int = 1, completion: @escaping (Result<MovieListResponse, APIError>) -> Void) {
        performRequest(endpoint: .topRated(page: page), type: .get, completion: completion)
    }

    func fetchMovieDetails(id: Int, completion: @escaping (Result<MovieDetailsResponse, APIError>) -> Void) {
        performRequest(endpoint: .movieDetails(id: id), type: .get, completion: completion)
    }

    func searchMovies(query: String, page: Int = 1, completion: @escaping (Result<MovieListResponse, APIError>) -> Void) {
        performRequest(endpoint: .search(query: query, page: page), type: .get, completion: completion)
    }

    // MARK: - Private Request Helper

    private func performRequest<T: Decodable>(
        endpoint: Endpoint,
        type: RequestType,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        guard let request = makeRequest(for: endpoint, type: type) else {
            completion(.failure(.invalidURL))
            return
        }

        AppLoger.log("Performing request: \(request)", type: .network)

        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self else {
                return
            }
            
            if error != nil {
                self.handleNetworkError(error, completion: completion)
            }
            
            if response != nil {
                self.validateResponse(response, completion: completion)
            }
            
            guard let data = self.validateData(data, completion: completion) else {
                return
            }

            self.decodeResponse(data, completion: completion)
        }

        task.resume()
    }
}

// MARK: - Request Builder

private extension APIClient {
    private func makeRequest(for endpoint: Endpoint, type: RequestType) -> URLRequest? {
        guard let bearerToken = bearerToken else {
            AppLoger.log("Bearer token not set", type: .error)
            return nil
        }
        
        guard let apiVersion = apiVersion else {
            AppLoger.log("API version not set", type: .error)
            return nil
        }

        guard var urlComponents = URLComponents(string: baseURL) else {
            AppLoger.log("Invalid base URL", type: .error)
            return nil
        }

        urlComponents.path = "/\(apiVersion)\(endpoint.path)"
        urlComponents.queryItems = endpoint.queryItems

        guard let url = urlComponents.url else {
            AppLoger.log("Invalid final URL", type: .error)
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = type.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}

// MARK: - Response Validators

private extension APIClient {
    @discardableResult
    func handleNetworkError<T>(
        _ error: Error?,
        completion: @escaping (Result<T, APIError>) -> Void
    ) -> Bool {
        guard let error = error else { return false }
        AppLoger.log("Network error: \(error.localizedDescription)", type: .error)
        completion(.failure(.networkError(error)))
        return true
    }

    @discardableResult
    func validateResponse<T>(
        _ response: URLResponse?,
        completion: @escaping (Result<T, APIError>) -> Void
    ) -> HTTPURLResponse? {
        guard let httpResponse = response as? HTTPURLResponse else {
            AppLoger.log("Invalid response: \(String(describing: response))", type: .error)
            completion(.failure(.networkError(NSError(domain: "Invalid response", code: -1))))
            return nil
        }

        AppLoger.log("HTTP Status Code: \(httpResponse.statusCode)", type: .network)

        guard (200...299).contains(httpResponse.statusCode) else {
            AppLoger.log("HTTP Error: \(httpResponse.statusCode)", type: .error)
            completion(.failure(.httpError(httpResponse.statusCode)))
            return nil
        }

        return httpResponse
    }

    @discardableResult
    func validateData<T>(
        _ data: Data?,
        completion: @escaping (Result<T, APIError>) -> Void
    ) -> Data? {
        guard let data = data else {
            AppLoger.log("No data received", type: .error)
            completion(.failure(.noData))
            return nil
        }
        return data
    }
}

// MARK: - Response Decoder

private extension APIClient {
    func decodeResponse<T: Decodable>(
        _ data: Data,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            AppLoger.log("✅ Successfully decoded response", type: .network)
            completion(.success(decoded))
        } catch let decodingError as DecodingError {
            AppLoger.log("Decoding error: \(decodingError)", type: .error)
            completion(.failure(.decodingError(decodingError)))
        } catch {
            AppLoger.log("Unexpected error: \(error)", type: .error)
            completion(.failure(.networkError(error)))
        }
    }

}
