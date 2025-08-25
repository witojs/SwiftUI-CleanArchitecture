//
//  GetScreenshotsUseCase.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 25/08/25.
//
import Combine

class GetScreenshotsUseCase {
    private let repository: GameRepository

    init(repository: GameRepository) {
        self.repository = repository
    }

    func execute(gameId: Int) -> AnyPublisher<[ScreenshotEntity], Error> {
        return repository.getScreenshots(for: gameId)
    }
}
