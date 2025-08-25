//
//  DetailViewModel.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

import Foundation

@MainActor
class DetailViewModel: ObservableObject {
    @Published var game: GameEntity?
    @Published var screenshots: [ScreenshotEntity] = []
    @Published var isLoading = false
    @Published var isFavorite: Bool = false
    
    private let gameId: Int
    private let getGameDetailUseCase: GetGameDetailUseCase
    private let getScreenshotsUseCase: GetScreenshotsUseCase
    private let addFavoriteUseCase: AddFavoriteUseCase
    private let removeFavoriteUseCase: RemoveFavoriteUseCase
    private let checkFavoriteStatusUseCase: CheckFavoriteStatusUseCase

    init(
        gameId: Int,
        getGameDetailUseCase: GetGameDetailUseCase,
        getScreenshotsUseCase: GetScreenshotsUseCase,
        addFavoriteUseCase: AddFavoriteUseCase,
        removeFavoriteUseCase: RemoveFavoriteUseCase,
        checkFavoriteStatusUseCase: CheckFavoriteStatusUseCase
    ) {
        self.gameId = gameId
        self.getGameDetailUseCase = getGameDetailUseCase
        self.getScreenshotsUseCase = getScreenshotsUseCase
        self.addFavoriteUseCase = addFavoriteUseCase
        self.removeFavoriteUseCase = removeFavoriteUseCase
        self.checkFavoriteStatusUseCase = checkFavoriteStatusUseCase
    }
    
    func loadGameDetails() {
        isLoading = true
        self.isFavorite = checkFavoriteStatusUseCase.execute(id: gameId)
        
        Task {
            do {
                async let gameDetail = getGameDetailUseCase.execute(id: gameId)
                async let gameScreenshots = getScreenshotsUseCase.execute(gameId: gameId)
                
                self.game = try await gameDetail
                self.screenshots = try await gameScreenshots
                
                self.isLoading = false
            } catch {
                print("Failed to load game details or screenshots: \(error)")
                self.isLoading = false
            }
        }
    }

    func toggleFavorite() {
        guard let game = self.game else { return }

        if isFavorite {
            do {
                try removeFavoriteUseCase.execute(id: game.id)
                self.isFavorite = false
            } catch {
                print(error.localizedDescription)
            }
        } else {
            do {
                try addFavoriteUseCase.execute(game: game)
                self.isFavorite = true
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
