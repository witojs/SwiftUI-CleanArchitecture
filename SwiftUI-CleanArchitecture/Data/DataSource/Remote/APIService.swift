//
//  APIService.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

import Foundation
import Alamofire

protocol APIServiceProtocol {
    func fetchGames(with query: String) async throws -> [Game]
    func fetchGameDetail(id: Int) async throws -> Game
    func fetchScreenshots(for gameId: Int) async throws -> [Screenshot]
}

class APIService: APIServiceProtocol {
    private let baseURL = "https://api.rawg.io/api"
    
    func fetchGames(with query: String) async throws -> [Game] {
        let url = "\(baseURL)/games"
        var parameters: [String: Any] = ["key": APIConstant.apiKey]
        if !query.isEmpty {
            parameters["search"] = query
        }
        
        return try await AF.request(url, parameters: parameters)
            .validate()
            .serializingDecodable(GameResponse.self)
            .value.results
    }
    
    func fetchGameDetail(id: Int) async throws -> Game {
        let url = "\(baseURL)/games/\(id)"
        let parameters: [String: Any] = ["key": APIConstant.apiKey]
        
        return try await AF.request(url, parameters: parameters)
            .validate()
            .serializingDecodable(Game.self)
            .value
    }
    
    func fetchScreenshots(for gameId: Int) async throws -> [Screenshot] {
        let url = "\(baseURL)/games/\(gameId)/screenshots"
        let parameters: [String: Any] = ["key": APIConstant.apiKey]
        
        return try await AF.request(url, parameters: parameters)
            .validate()
            .serializingDecodable(ScreenshotsResponse.self)
            .value.results
    }
}
