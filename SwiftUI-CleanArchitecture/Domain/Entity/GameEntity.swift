//
//  GameEntity.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

struct GameEntity: Identifiable, Hashable {
    let id: Int
    let name: String
    let released: String
    let backgroundImage: String
    let rating: Double
    let description: String
    let metacritic: Int
    let genres: [String]
    let platforms: [String]
    let developers: [String]
}

struct ScreenshotEntity: Identifiable, Hashable {
    let id: Int
    let imageURL: String
}
