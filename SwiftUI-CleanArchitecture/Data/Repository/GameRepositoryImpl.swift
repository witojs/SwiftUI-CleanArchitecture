//
//  GameRepositoryImpl.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

class GameRepositoryImpl: GameRepository {
    private let remoteDataSource: APIServiceProtocol
    private let localDataSource: LocalDataSourceProtocol
    
    init(remoteDataSource: APIServiceProtocol, localDataSource: LocalDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    // --- Remote ---
    func getGames(query: String) async throws -> [GameEntity] {
        let games = try await remoteDataSource.fetchGames(with: query)
        // Map from Data model to Domain entity
        return games.map { $0.toEntity() }
    }
    
    func getGameDetail(id: Int) async throws -> GameEntity {
        // 1. Call the remote data source's detail endpoint.
        let gameDetail = try await remoteDataSource.fetchGameDetail(id: id)
        // 2. Map the detailed `Game` DTO to a clean `GameEntity`.
        return gameDetail.toEntity()
    }
    
    func getScreenshots(for gameId: Int) async throws -> [ScreenshotEntity] {
        let screenshots = try await remoteDataSource.fetchScreenshots(for: gameId)
        return screenshots.map { $0.toEntity() }
    }
    
    // --- Local ---
    func addFavorite(_ game: GameEntity) throws {
        try localDataSource.addFavorite(game.toFavoriteGame())
    }
    
    func removeFavorite(id: Int) throws {
        try localDataSource.removeFavorite(id: id)
    }
    
    func isFavorite(id: Int) -> Bool {
        return localDataSource.isFavorite(id: id)
    }
    
    func getFavorites() throws -> [GameEntity] {
        // 1. Call the local data source to fetch the raw `FavoriteGame` objects.
        let favoriteGames = try localDataSource.getFavorites()
        
        // 2. Map the array of `FavoriteGame` models to an array of `GameEntity` models.
        // This ensures the data returned is in the clean, domain-centric format.
        return favoriteGames.map { $0.toEntity() }
    }
}

// Mapper functions to convert between models
extension Game {
    func toEntity() -> GameEntity {
        .init(
            id: self.id,
            name: self.name,
            released: self.released ?? "N/A",
            backgroundImage: self.backgroundImage ?? "",
            rating: self.rating ?? 0.0,
            description: self.descriptionRaw ?? "No description available.",
            metacritic: self.metacritic ?? 0,
            genres: self.genres?.map { $0.name } ?? [],
            platforms: self.platforms?.map { $0.platform.name } ?? [],
            developers: self.developers?.map { $0.name } ?? []
        )
    }
}

extension GameEntity {
    func toFavoriteGame() -> FavoriteGame {
        .init(
            id: self.id,
            name: self.name,
            released: self.released,
            backgroundImage: self.backgroundImage,
            rating: self.rating,
            gameDescription: self.description,
            // Pass the new data to be saved
            metacritic: self.metacritic,
            genres: self.genres,
            platforms: self.platforms,
            developers: self.developers
        )
    }
}

extension Screenshot {
    func toEntity() -> ScreenshotEntity {
        .init(id: self.id, imageURL: self.image)
    }
}

extension FavoriteGame {
    func toEntity() -> GameEntity {
        .init(
            id: self.id,
            name: self.name,
            released: self.released,
            backgroundImage: self.backgroundImage,
            rating: self.rating,
            description: self.gameDescription, // Use the saved description
            // Load the new data from the database object
            metacritic: self.metacritic,
            genres: self.genres,
            platforms: self.platforms,
            developers: self.developers
        )
    }
}
