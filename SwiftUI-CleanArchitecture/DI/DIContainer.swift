//
//  DIContainer.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

import Foundation

@MainActor
class DIContainer {
    // Singletons for data sources
    lazy var apiService: APIServiceProtocol = APIService()
    lazy var localDataSource: LocalDataSourceProtocol = LocalDataSource()
    
    // The repository is also a good candidate for a singleton instance
    lazy var gameRepository: GameRepository = GameRepositoryImpl(
        remoteDataSource: apiService,
        localDataSource: localDataSource
    )
    
    // --- Use Cases ---
    // Use cases are lightweight and can be created on demand
    func makeGetGamesUseCase() -> GetGamesUseCase {
        GetGamesUseCase(repository: gameRepository)
    }
    
    func makeGetGameDetailUseCase() -> GetGameDetailUseCase {
        GetGameDetailUseCase(repository: gameRepository)
    }
    
    func makeGetScreenshotsUseCase() -> GetScreenshotsUseCase {
        GetScreenshotsUseCase(repository: gameRepository)
    }
    
    func makeAddFavoriteUseCase() -> AddFavoriteUseCase {
        AddFavoriteUseCase(repository: gameRepository)
    }
    
    func makeRemoveFavoriteUseCase() -> RemoveFavoriteUseCase {
        RemoveFavoriteUseCase(repository: gameRepository)
    }
    
    func makeCheckFavoriteStatusUseCase() -> CheckFavoriteStatusUseCase {
        CheckFavoriteStatusUseCase(repository: gameRepository)
    }
    
    func makeGetFavoritesUseCase() -> GetFavoritesUseCase {
        GetFavoritesUseCase(repository: gameRepository)
    }
    
    // --- ViewModels ---
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(getGamesUseCase: makeGetGamesUseCase())
    }
    
    func makeDetailViewModel(for gameId: Int) -> DetailViewModel {
        DetailViewModel(
            gameId: gameId,
            getGameDetailUseCase: makeGetGameDetailUseCase(),
            getScreenshotsUseCase: makeGetScreenshotsUseCase(), // Inject new dependency
            addFavoriteUseCase: makeAddFavoriteUseCase(),
            removeFavoriteUseCase: makeRemoveFavoriteUseCase(),
            checkFavoriteStatusUseCase: makeCheckFavoriteStatusUseCase()
        )
    }
    
    func makeFavoriteViewModel() -> FavoriteViewModel {
        FavoriteViewModel(
            getFavoritesUseCase: makeGetFavoritesUseCase(),
            removeFavoriteUseCase: makeRemoveFavoriteUseCase()
        )
    }
    
    // --- Views (Factory method) ---
    // To make navigation easier, we can have the container build the DetailView too
    func makeDetailView(for gameId: Int) -> DetailView {
        let viewModel = makeDetailViewModel(for: gameId)
        return DetailView(viewModel: viewModel)
    }
}
