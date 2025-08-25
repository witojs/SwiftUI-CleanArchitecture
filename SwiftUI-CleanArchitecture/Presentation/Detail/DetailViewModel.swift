//
//  DetailViewModel.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

import Foundation
import Combine

@MainActor
class DetailViewModel: ObservableObject {
    @Published var game: GameEntity?
    @Published var screenshots: [ScreenshotEntity] = []
    @Published var isLoading = false
    @Published var isFavorite: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let gameId: Int
    private let getGameDetailUseCase: GetGameDetailUseCase
    private let getScreenshotsUseCase: GetScreenshotsUseCase
    private let addFavoriteUseCase: AddFavoriteUseCase
    private let removeFavoriteUseCase: RemoveFavoriteUseCase
    private let checkFavoriteStatusUseCase: CheckFavoriteStatusUseCase
    private let favoriteStatusService: FavoriteStatusServiceProtocol

    init(
        gameId: Int,
        getGameDetailUseCase: GetGameDetailUseCase,
        getScreenshotsUseCase: GetScreenshotsUseCase,
        addFavoriteUseCase: AddFavoriteUseCase,
        removeFavoriteUseCase: RemoveFavoriteUseCase,
        checkFavoriteStatusUseCase: CheckFavoriteStatusUseCase,
        favoriteStatusService: FavoriteStatusServiceProtocol
    ) {
        self.gameId = gameId
        self.getGameDetailUseCase = getGameDetailUseCase
        self.getScreenshotsUseCase = getScreenshotsUseCase
        self.addFavoriteUseCase = addFavoriteUseCase
        self.removeFavoriteUseCase = removeFavoriteUseCase
        self.checkFavoriteStatusUseCase = checkFavoriteStatusUseCase
        self.favoriteStatusService = favoriteStatusService
        subscribeToFavoriteChanges()
    }
    
    func loadGameDetails() {
        isLoading = true
        
        let detailPublisher = getGameDetailUseCase.execute(id: gameId)
        let screenshotsPublisher = getScreenshotsUseCase.execute(gameId: gameId)
        
        Publishers.Zip(detailPublisher, screenshotsPublisher)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    // Handle error
                    print(error.localizedDescription)
                }
            }, receiveValue: { [weak self] (gameDetail, gameScreenshots) in
                self?.game = gameDetail
                self?.screenshots = gameScreenshots
            })
            .store(in: &cancellables)
            
        // Also check favorite status
        checkFavoriteStatusUseCase.execute(id: gameId)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] isFav in
                self?.isFavorite = isFav
            })
            .store(in: &cancellables)
    }

    func toggleFavorite() {
        guard let game = self.game else { return }
        
        let publisher = isFavorite ? removeFavoriteUseCase.execute(id: game.id) : addFavoriteUseCase.execute(game: game)
        
        publisher
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] _ in
                guard let self = self else { return }
                
                self.isFavorite.toggle()
                
                self.favoriteStatusService.post(gameId: self.gameId, isFavorite: self.isFavorite)
            })
            .store(in: &cancellables)
    }
    
    private func subscribeToFavoriteChanges() {
        favoriteStatusService.statusDidChange
            .receive(on: RunLoop.main)
            .filter { [weak self] change in
                return change.gameId == self?.gameId
            }
            .sink { [weak self] change in
                self?.isFavorite = change.isFavorite
            }
            .store(in: &cancellables)
    }
}
