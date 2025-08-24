//
//  GetFavoritesUseCase.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

class GetFavoritesUseCase {
    // It depends on the repository protocol, not the concrete implementation.
    private let repository: GameRepository

    init(repository: GameRepository) {
        self.repository = repository
    }

    // The execution method calls the repository and returns the data.
    // It can also contain business logic, like sorting the favorites by name.
    func execute() throws -> [GameEntity] {
        return try repository.getFavorites().sorted { $0.name < $1.name }
    }
}
