//
//  GetGameDetailUseCase.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

import Foundation

class GetGameDetailUseCase {
    private let repository: GameRepository

    init(repository: GameRepository) {
        self.repository = repository
    }

    func execute(id: Int) async throws -> GameEntity {
        return try await repository.getGameDetail(id: id)
    }
}
