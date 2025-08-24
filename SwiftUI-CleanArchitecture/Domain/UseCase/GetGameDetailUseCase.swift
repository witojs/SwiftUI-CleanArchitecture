//
//  GetGameDetailUseCase.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

import Foundation

// This class's only job is to get the full details for a single game.
class GetGameDetailUseCase {
    private let repository: GameRepository

    init(repository: GameRepository) {
        self.repository = repository
    }

    // It takes a game ID and asks the repository for the complete GameEntity.
    func execute(id: Int) async throws -> GameEntity {
        return try await repository.getGameDetail(id: id)
    }
}
