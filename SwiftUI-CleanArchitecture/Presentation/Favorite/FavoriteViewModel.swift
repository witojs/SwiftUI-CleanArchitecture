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
                }
            }, receiveValue: { [weak self] games in
                self?.favoriteGames = games
            })
            .store(in: &cancellables)
    }
    
    // for remove favorite from button action
    func removeFavorite(game: GameEntity) {
        removeFavoriteUseCase.execute(id: game.id)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error removing favorite: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] _ in
                guard let self = self else { return }
                
                self.favoriteStatusService.post(gameId: game.id, isFavorite: false)
                self.fetchFavorites()
            })
            .store(in: &cancellables)
    }
    
    func removeFavorite(at offsets: IndexSet) {
        let gamesToRemove = offsets.map { favoriteGames[$0] }
        
        favoriteGames.remove(atOffsets: offsets)
        
        for game in gamesToRemove {
            removeFavoriteUseCase.execute(id: game.id)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Error removing favorite from database: \(error.localizedDescription)")
                        self.fetchFavorites() // Refetch to correct the UI state
                    }
                }, receiveValue: { [weak self] _ in
                    self?.favoriteStatusService.post(gameId: game.id, isFavorite: false)
                })
                .store(in: &cancellables)
        }
    }
}
