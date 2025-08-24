//
//  DetailViewModel.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

import Foundation

@MainActor
class DetailViewModel: ObservableObject {
    // --- State Properties ---
    // The game object is now optional and @Published. The view will update when it's loaded.
    @Published var game: GameEntity?
    @Published var screenshots: [ScreenshotEntity] = []
    @Published var isLoading = false
    @Published var isFavorite: Bool = false
    
    // --- Dependencies (Use Cases) ---
    private let gameId: Int // We now only need the ID to start.
    private let getGameDetailUseCase: GetGameDetailUseCase
    private let getScreenshotsUseCase: GetScreenshotsUseCase
    private let addFavoriteUseCase: AddFavoriteUseCase
    private let removeFavoriteUseCase: RemoveFavoriteUseCase
    private let checkFavoriteStatusUseCase: CheckFavoriteStatusUseCase

    init(
        gameId: Int, // It now accepts a gameId instead of a full GameEntity.
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
    
    // This function triggers the data fetching.
    func loadGameDetails() {
        isLoading = true
        self.isFavorite = checkFavoriteStatusUseCase.execute(id: gameId)
        
        Task {
            do {
                // Fetch details and screenshots concurrently
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

    // The toggle logic now safely unwraps the full game object.
    func toggleFavorite() {
        // Ensure we have the full game details before trying to favorite.
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
                // Now, when we save, the `game` object contains the full description.
                try addFavoriteUseCase.execute(game: game)
                self.isFavorite = true
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
