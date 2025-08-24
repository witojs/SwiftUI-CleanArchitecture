//
//  FavoriteGame.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

import Foundation
import SwiftData

@Model
final class FavoriteGame {
    @Attribute(.unique) var id: Int
    var name: String
    var released: String
    var backgroundImage: String
    var rating: Double
    var gameDescription: String
    
    // --- NEW PROPERTIES TO SAVE ---
    var metacritic: Int
    var genres: [String]
    var platforms: [String]
    var developers: [String]

    init(
        id: Int,
        name: String,
        released: String,
        backgroundImage: String,
        rating: Double,
        gameDescription: String,
        metacritic: Int,
        genres: [String],
        platforms: [String],
        developers: [String]
    ) {
        self.id = id
        self.name = name
        self.released = released
        self.backgroundImage = backgroundImage
        self.rating = rating
        self.gameDescription = gameDescription
        self.metacritic = metacritic
        self.genres = genres
        self.platforms = platforms
        self.developers = developers
    }
}
