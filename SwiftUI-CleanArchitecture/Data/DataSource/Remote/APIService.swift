//
//  APIService.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

import Foundation
import Alamofire
import Combine

protocol APIServiceProtocol {
    func fetchGames(with query: String) -> AnyPublisher<[Game], Error>
    func fetchGameDetail(id: Int) -> AnyPublisher<Game, Error>
    func fetchScreenshots(for gameId: Int) -> AnyPublisher<[Screenshot], Error>
}

class APIService: APIServiceProtocol {
    private let baseURL = "https://api.rawg.io/api"
    
    // 3. Implement the new protocol method for fetching games
    func fetchGames(with query: String) -> AnyPublisher<[Game], Error> {
        let url = "\(baseURL)/games"
        var parameters: [String: Any] = ["key": APIConstant.apiKey]
        if !query.isEmpty {
            parameters["search"] = query
        }
        
        // Use Alamofire's `publishDecodable` which returns a publisher
        return AF.request(url, parameters: parameters)
            .validate()
            .publishDecodable(type: GameResponse.self)
            .value() // Get the publisher for the decoded value
            .map { $0.results } // Map the response to get just the results array
            .mapError { $0 as Error } // Ensure the error type is consistent
            .eraseToAnyPublisher() // Erase the complex type to a simple AnyPublisher
    }
    
    // 4. Implement for fetching game detail
    func fetchGameDetail(id: Int) -> AnyPublisher<Game, Error> {
        let url = "\(baseURL)/games/\(id)"
        let parameters: [String: Any] = ["key": APIConstant.apiKey]
        
        return AF.request(url, parameters: parameters)
            .validate()
            .publishDecodable(type: Game.self)
            .value()
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }

    // 5. Implement for fetching screenshots
    func fetchScreenshots(for gameId: Int) -> AnyPublisher<[Screenshot], Error> {
        let url = "\(baseURL)/games/\(gameId)/screenshots"
        let parameters: [String: Any] = ["key": APIConstant.apiKey]
        
        return AF.request(url, parameters: parameters)
            .validate()
            .publishDecodable(type: ScreenshotsResponse.self)
            .value()
            .map { $0.results }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
