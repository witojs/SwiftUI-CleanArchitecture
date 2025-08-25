//
//  GetFavoritesUseCase.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//
import Combine

class GetFavoritesUseCase {
    private let repository: GameRepository

    init(repository: GameRepository) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<[GameEntity], Error> {
        return repository.getFavorites()
            .map { $0.sorted { $0.name < $1.name } }
            .eraseToAnyPublisher()
    }
}
