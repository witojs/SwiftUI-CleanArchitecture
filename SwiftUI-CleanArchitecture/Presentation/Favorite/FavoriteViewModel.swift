//
//  FavoriteViewModel.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

import Foundation
import Combine

@MainActor
class FavoriteViewModel: ObservableObject {
    @Published var favoriteGames: [GameEntity] = []
    
    private let getFavoritesUseCase: GetFavoritesUseCase
    private let removeFavoriteUseCase: RemoveFavoriteUseCase
    private let favoriteStatusService: FavoriteStatusServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        getFavoritesUseCase: GetFavoritesUseCase,
        removeFavoriteUseCase: RemoveFavoriteUseCase,
        favoriteStatusService: FavoriteStatusServiceProtocol
    ) {
        self.getFavoritesUseCase = getFavoritesUseCase
        self.removeFavoriteUseCase = removeFavoriteUseCase
        self.favoriteStatusService = favoriteStatusService
    }
    
    func fetchFavorites() {
        getFavoritesUseCase.execute()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching favorites: \(error.localizedDescription)")
                    // In a real app, you might want to set an error state here
                }
            }, receiveValue: { [weak self] games in
                self?.favoriteGames = games
            })
            .store(in: &cancellables)
    }
    
    // for remove favorite from button action
    func removeFavorite(game: GameEntity) {
        // Call the use case which returns a publisher
        removeFavoriteUseCase.execute(id: game.id)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                // Handle any errors from the database operation
                if case .failure(let error) = completion {
                    print("Error removing favorite: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] _ in
                // This closure is called on successful completion
                guard let self = self else { return }
                
                // 1. Broadcast that this game is no longer a favorite
                self.favoriteStatusService.post(gameId: game.id, isFavorite: false)
                
                // 2. Refetch the list to ensure the UI is up-to-date
                self.fetchFavorites()
            })
            .store(in: &cancellables)
    }
    
    func removeFavorite(at offsets: IndexSet) {
        let gamesToRemove = offsets.map { favoriteGames[$0] }
        
        // This provides instant UI feedback, which is a great user experience.
        favoriteGames.remove(atOffsets: offsets)
        
        // This performs the actual database deletion in the background for each removed item.
        for game in gamesToRemove {
            removeFavoriteUseCase.execute(id: game.id)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        // If the database deletion fails, the UI will be out of sync.
                        // A robust solution would be to refetch the list from the DB
                        // to ensure consistency, and show an alert to the user.
                        print("Error removing favorite from database: \(error.localizedDescription)")
                        self.fetchFavorites() // Refetch to correct the UI state
                    }
                }, receiveValue: { [weak self] _ in
                    // ✅ Broadcast that this game is no longer a favorite.
                    self?.favoriteStatusService.post(gameId: game.id, isFavorite: false)
                })
                .store(in: &cancellables)
        }
    }
}
