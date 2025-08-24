//
//  FavoriteUseCase.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

class AddFavoriteUseCase {
    private let repository: GameRepository
    init(repository: GameRepository) { self.repository = repository }
    func execute(game: GameEntity) throws {
        try repository.addFavorite(game)
    }
}

class RemoveFavoriteUseCase {
    private let repository: GameRepository
    init(repository: GameRepository) { self.repository = repository }
    func execute(id: Int) throws {
        try repository.removeFavorite(id: id)
    }
}

class CheckFavoriteStatusUseCase {
    private let repository: GameRepository
    init(repository: GameRepository) { self.repository = repository }
    func execute(id: Int) -> Bool {
        return repository.isFavorite(id: id)
    }
}
