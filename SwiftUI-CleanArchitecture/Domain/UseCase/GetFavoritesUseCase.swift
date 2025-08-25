//
//  GetFavoritesUseCase.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

class GetFavoritesUseCase {
    private let repository: GameRepository

    init(repository: GameRepository) {
        self.repository = repository
    }

    func execute() throws -> [GameEntity] {
        return try repository.getFavorites().sorted { $0.name < $1.name }
    }
}
