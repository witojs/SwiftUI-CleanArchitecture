//
//  FavoriteViewModel.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

import Foundation

@MainActor
class FavoriteViewModel: ObservableObject {
    @Published var favoriteGames: [GameEntity] = []
    
    private let getFavoritesUseCase: GetFavoritesUseCase
    private let removeFavoriteUseCase: RemoveFavoriteUseCase
    
    init(getFavoritesUseCase: GetFavoritesUseCase, removeFavoriteUseCase: RemoveFavoriteUseCase) {
        self.getFavoritesUseCase = getFavoritesUseCase
        self.removeFavoriteUseCase = removeFavoriteUseCase
    }
    
    func fetchFavorites() {
        do {
            self.favoriteGames = try getFavoritesUseCase.execute()
        } catch {
            print("Error fetching favorites: \(error.localizedDescription)")
            self.favoriteGames = []
        }
    }
    
    // for remove favorite from button action
    func removeFavorite(game: GameEntity) {
        do {
            try removeFavoriteUseCase.execute(id: game.id)
            fetchFavorites()
        } catch {
            print("Error removing favorite: \(error.localizedDescription)")
        }
    }
    
    func removeFavorite(at offsets: IndexSet) {
        let gamesToRemove = offsets.map { favoriteGames[$0] }
        
        for game in gamesToRemove {
            do {
                try removeFavoriteUseCase.execute(id: game.id)
            } catch {
                print("Error removing favorite: \(error.localizedDescription)")
            }
        }
        

        favoriteGames.remove(atOffsets: offsets)
    }
}
