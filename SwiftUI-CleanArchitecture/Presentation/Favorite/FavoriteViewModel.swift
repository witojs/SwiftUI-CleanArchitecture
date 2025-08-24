//
//  FavoriteViewModel.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

import Foundation

@MainActor
class FavoriteViewModel: ObservableObject {
    // --- State Properties ---
    // This will hold the list of favorite games to be displayed.
    @Published var favoriteGames: [GameEntity] = []
    
    // --- Dependencies (Use Cases) ---
    private let getFavoritesUseCase: GetFavoritesUseCase
    private let removeFavoriteUseCase: RemoveFavoriteUseCase
    
    init(getFavoritesUseCase: GetFavoritesUseCase, removeFavoriteUseCase: RemoveFavoriteUseCase) {
        self.getFavoritesUseCase = getFavoritesUseCase
        self.removeFavoriteUseCase = removeFavoriteUseCase
    }
    
    // Fetches the list of favorites from the use case and updates the state.
    func fetchFavorites() {
        do {
            self.favoriteGames = try getFavoritesUseCase.execute()
        } catch {
            // In a real app, you would publish an error message to the view.
            print("Error fetching favorites: \(error.localizedDescription)")
            self.favoriteGames = []
        }
    }
    
    // Removes a favorite and then refreshes the list to update the UI.
    func removeFavorite(game: GameEntity) {
        do {
            try removeFavoriteUseCase.execute(id: game.id)
            // After successfully removing, we call fetchFavorites() again
            // to get the updated list, which will cause the SwiftUI view to refresh.
            fetchFavorites()
        } catch {
            print("Error removing favorite: \(error.localizedDescription)")
        }
    }
    
    func removeFavorite(at offsets: IndexSet) {
        // 1. Get the game objects that correspond to the swiped indices.
        let gamesToRemove = offsets.map { favoriteGames[$0] }
        
        // 2. Loop through them and call the use case to remove from the database.
        for game in gamesToRemove {
            do {
                try removeFavoriteUseCase.execute(id: game.id)
            } catch {
                // Handle potential errors, e.g., show an alert.
                print("Error removing favorite: \(error.localizedDescription)")
            }
        }
        
        // 3. Immediately remove the items from the local array to update the UI instantly.
        favoriteGames.remove(atOffsets: offsets)
    }
}
