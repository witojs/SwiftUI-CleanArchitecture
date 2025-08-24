//
//  GameRepository.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

protocol GameRepository {
    func getGames(query: String) async throws -> [GameEntity]
    func getGameDetail(id: Int) async throws -> GameEntity
    func getScreenshots(for gameId: Int) async throws -> [ScreenshotEntity]
    func addFavorite(_ game: GameEntity) throws
    func removeFavorite(id: Int) throws
    func isFavorite(id: Int) -> Bool
    func getFavorites() throws -> [GameEntity]
}
