//
//  HomeViewModel.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var games: [GameEntity] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""

    private let getGamesUseCase: GetGamesUseCase
    private var cancellables = Set<AnyCancellable>()
    
    var featuredGames: [GameEntity] {
        games.filter { $0.rating >= 4.5 }
    }
    
    // This computed property returns all other games.
    var allGames: [GameEntity] {
        games.filter { $0.rating < 4.5 }
    }

    init(getGamesUseCase: GetGamesUseCase) {
        self.getGamesUseCase = getGamesUseCase
        
        // Use Combine to react to search text changes
        $searchText
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main) // Wait for user to stop typing
            .removeDuplicates()
            .sink { [weak self] query in
                self?.fetchGames(query: query)
            }
            .store(in: &cancellables)
    }

    func fetchGames(query: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                self.games = try await getGamesUseCase.execute(query: query)
            } catch {
                self.errorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }
}
