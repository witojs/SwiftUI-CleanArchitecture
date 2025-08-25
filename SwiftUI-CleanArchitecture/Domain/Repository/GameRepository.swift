//
//  GameRepository.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//
import Combine

protocol GameRepository {
    func getGames(query: String) -> AnyPublisher<[GameEntity], Error>
    func getGameDetail(id: Int) -> AnyPublisher<GameEntity, Error>
    func getScreenshots(for gameId: Int) -> AnyPublisher<[ScreenshotEntity], Error>
    func addFavorite(_ game: GameEntity) -> AnyPublisher<Void, Error>
    func removeFavorite(id: Int) -> AnyPublisher<Void, Error>
    func isFavorite(id: Int) -> AnyPublisher<Bool, Error>
    func getFavorites() -> AnyPublisher<[GameEntity], Error>
}
