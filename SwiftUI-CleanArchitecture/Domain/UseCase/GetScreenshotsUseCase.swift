//
//  GetScreenshotsUseCase.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 25/08/25.
//

class GetScreenshotsUseCase {
    private let repository: GameRepository

    init(repository: GameRepository) {
        self.repository = repository
    }

    func execute(gameId: Int) async throws -> [ScreenshotEntity] {
        return try await repository.getScreenshots(for: gameId)
    }
}
