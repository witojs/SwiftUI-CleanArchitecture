//
//  GetGameDetailUseCase.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

import Foundation
import Combine

class GetGameDetailUseCase {
    private let repository: GameRepository

    init(repository: GameRepository) {
        self.repository = repository
    }

    func execute(id: Int) -> AnyPublisher<GameEntity, Error> {
        return repository.getGameDetail(id: id)
    }
}
