//
//  DIContainer.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

import Foundation

@MainActor
class DIContainer: ObservableObject {
    lazy var apiService: APIServiceProtocol = APIService()
    lazy var localDataSource: LocalDataSourceProtocol = LocalDataSource()
    lazy var favoriteStatusService: FavoriteStatusServiceProtocol = FavoriteStatusService()
    
    lazy var gameRepository: GameRepository = GameRepositoryImpl(
        remoteDataSource: apiService,
        localDataSource: localDataSource
    )
    
    // --- Use Cases ---
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
            checkFavoriteStatusUseCase: makeCheckFavoriteStatusUseCase(),
            favoriteStatusService: favoriteStatusService
        )
    }
    
    func makeFavoriteViewModel() -> FavoriteViewModel {
        FavoriteViewModel(
            getFavoritesUseCase: makeGetFavoritesUseCase(),
            removeFavoriteUseCase: makeRemoveFavoriteUseCase(),
            favoriteStatusService: favoriteStatusService
        )
    }
    
    // --- Views (Factory method) ---
    func makeDetailView(for gameId: Int) -> DetailView {
        let viewModel = makeDetailViewModel(for: gameId)
        return DetailView(viewModel: viewModel)
    }
}
