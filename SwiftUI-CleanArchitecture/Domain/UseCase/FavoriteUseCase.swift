//
//  FavoriteUseCase.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//
import Combine

class AddFavoriteUseCase {
    private let repository: GameRepository
    init(repository: GameRepository) { self.repository = repository }
    func execute(game: GameEntity) -> AnyPublisher<Void, Error> {
        return repository.addFavorite(game)
    }
}

class RemoveFavoriteUseCase {
    private let repository: GameRepository
    init(repository: GameRepository) { self.repository = repository }
    func execute(id: Int) -> AnyPublisher<Void, Error> {
        return repository.removeFavorite(id: id)
    }
}

class CheckFavoriteStatusUseCase {
    private let repository: GameRepository
    init(repository: GameRepository) { self.repository = repository }
    func execute(id: Int) -> AnyPublisher<Bool, Error> {
        return repository.isFavorite(id: id)
    }
}
