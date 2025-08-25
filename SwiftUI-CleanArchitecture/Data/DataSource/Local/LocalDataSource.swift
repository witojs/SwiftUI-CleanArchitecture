//
//  LocalDataSource.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

import Foundation
import SwiftData
import Combine

protocol LocalDataSourceProtocol {
    func addFavorite(_ game: FavoriteGame) -> AnyPublisher<Void, Error>
    func removeFavorite(id: Int) -> AnyPublisher<Void, Error>
    func isFavorite(id: Int) -> AnyPublisher<Bool, Error>
    func getFavorites() -> AnyPublisher<[FavoriteGame], Error>
}

class LocalDataSource: LocalDataSourceProtocol {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @MainActor
    init() {
        self.modelContainer = try! ModelContainer(for: FavoriteGame.self)
        self.modelContext = modelContainer.mainContext
    }

    func addFavorite(_ game: FavoriteGame) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            do {
                self?.modelContext.insert(game)
                try self?.modelContext.save()
                promise(.success(())) // Signal success
            } catch {
                promise(.failure(error)) // Signal failure
            }
        }.eraseToAnyPublisher()
    }

    func removeFavorite(id: Int) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            guard let self = self else { return }
            do {
                let predicate = #Predicate<FavoriteGame> { $0.id == id }
                try self.modelContext.delete(model: FavoriteGame.self, where: predicate)
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    func isFavorite(id: Int) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { [weak self] promise in
            guard let self = self else { return }
            do {
                let predicate = #Predicate<FavoriteGame> { $0.id == id }
                var descriptor = FetchDescriptor(predicate: predicate)
                descriptor.fetchLimit = 1
                let count = try self.modelContext.fetchCount(descriptor)
                promise(.success(count > 0))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }

    func getFavorites() -> AnyPublisher<[FavoriteGame], Error> {
        return Future<[FavoriteGame], Error> { [weak self] promise in
            guard let self = self else { return }
            do {
                let favorites = try self.modelContext.fetch(FetchDescriptor<FavoriteGame>())
                promise(.success(favorites))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
}
