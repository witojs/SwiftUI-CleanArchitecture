//
//  LocalDataSource.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

import Foundation
import SwiftData

protocol LocalDataSourceProtocol {
    func addFavorite(_ game: FavoriteGame) throws
    func removeFavorite(id: Int) throws
    func isFavorite(id: Int) -> Bool
    func getFavorites() throws -> [FavoriteGame]
}

class LocalDataSource: LocalDataSourceProtocol {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext

    @MainActor
    init() {
        self.modelContainer = try! ModelContainer(for: FavoriteGame.self)
        self.modelContext = modelContainer.mainContext
    }

    func addFavorite(_ game: FavoriteGame) throws {
        modelContext.insert(game)
        try modelContext.save()
    }

    func removeFavorite(id: Int) throws {
        let predicate = #Predicate<FavoriteGame> { $0.id == id }
        try modelContext.delete(model: FavoriteGame.self, where: predicate)
    }

    func isFavorite(id: Int) -> Bool {
        let predicate = #Predicate<FavoriteGame> { $0.id == id }
        var descriptor = FetchDescriptor(predicate: predicate)
        descriptor.fetchLimit = 1
        
        do {
            let count = try modelContext.fetchCount(descriptor)
            return count > 0
        } catch {
            return false
        }
    }

    func getFavorites() throws -> [FavoriteGame] {
        try modelContext.fetch(FetchDescriptor<FavoriteGame>())
    }
}
