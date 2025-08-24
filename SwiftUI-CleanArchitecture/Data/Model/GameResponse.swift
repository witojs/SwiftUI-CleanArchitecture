//
//  GameResponse.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

struct GameResponse: Codable {
    let results: [Game]
}

struct Game: Codable, Identifiable {
    let id: Int
    let name: String
    let released: String?
    let backgroundImage: String?
    let rating: Double?
    let descriptionRaw: String?
    let metacritic: Int?
    let genres: [Genre]?
    let platforms: [PlatformWrapper]?
    let developers: [Developer]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, released, rating, genres, platforms, developers, metacritic
        case backgroundImage = "background_image"
        case descriptionRaw = "description_raw"
    }
}

struct Genre: Codable, Identifiable {
    let id: Int
    let name: String
}

struct PlatformWrapper: Codable {
    let platform: Platform
}

struct Platform: Codable, Identifiable {
    let id: Int
    let name: String
}

struct Developer: Codable, Identifiable {
    let id: Int
    let name: String
}
