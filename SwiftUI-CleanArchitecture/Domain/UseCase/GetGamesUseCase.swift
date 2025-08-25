//
//  GetGamesUseCase.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//
import Combine

class GetGamesUseCase {
    private let repository: GameRepository

    init(repository: GameRepository) {
        self.repository = repository
    }

    func execute(query: String) -> AnyPublisher<[GameEntity], Error> {
        return repository.getGames(query: query)
            .map { $0.sorted { $0.rating > $1.rating } }
            .eraseToAnyPublisher()
    }
}
