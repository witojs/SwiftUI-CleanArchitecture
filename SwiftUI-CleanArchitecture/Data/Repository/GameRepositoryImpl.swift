//
//  GameRepositoryImpl.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//
import Combine

class GameRepositoryImpl: GameRepository {
    private let remoteDataSource: APIServiceProtocol
    private let localDataSource: LocalDataSourceProtocol
    
    init(remoteDataSource: APIServiceProtocol, localDataSource: LocalDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    // --- Remote ---
    func getGames(query: String) -> AnyPublisher<[GameEntity], Error> {
        return remoteDataSource.fetchGames(with: query)
            .map { $0.map { $0.toEntity() } } // Map the array of Games to GameEntities
            .eraseToAnyPublisher()
    }
    
    func getGameDetail(id: Int) -> AnyPublisher<GameEntity, Error> {
        return remoteDataSource.fetchGameDetail(id: id)
            .map { $0.toEntity() } // Map the single Game to a GameEntity
            .eraseToAnyPublisher()
    }
    
    func getScreenshots(for gameId: Int) -> AnyPublisher<[ScreenshotEntity], Error> {
        return remoteDataSource.fetchScreenshots(for: gameId)
            .map { $0.map { $0.toEntity() } }
            .eraseToAnyPublisher()
    }
    
    // --- Local ---
    func addFavorite(_ game: GameEntity) -> AnyPublisher<Void, Error> {
        return localDataSource.addFavorite(game.toFavoriteGame())
    }
    
    func removeFavorite(id: Int) -> AnyPublisher<Void, Error> {
        return localDataSource.removeFavorite(id: id)
    }
    
    func isFavorite(id: Int) -> AnyPublisher<Bool, Error> {
        return localDataSource.isFavorite(id: id)
    }
    
    func getFavorites() -> AnyPublisher<[GameEntity], Error> {
        return localDataSource.getFavorites()
            .map { $0.map { $0.toEntity() } }
            .eraseToAnyPublisher()
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
            description: self.gameDescription,
            metacritic: self.metacritic,
            genres: self.genres,
            platforms: self.platforms,
            developers: self.developers
        )
    }
}
