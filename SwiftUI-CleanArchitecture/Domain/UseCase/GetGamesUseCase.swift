//
//  GetGamesUseCase.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

class GetGamesUseCase {
    private let repository: GameRepository

    init(repository: GameRepository) {
        self.repository = repository
    }

    func execute(query: String) async throws -> [GameEntity] {
        return try await repository.getGames(query: query)
            .sorted { $0.rating > $1.rating } 
    }
}
