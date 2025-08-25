//
//  FavoriteStatusService.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 25/08/25.
//
import Combine

struct FavoriteStatusChange {
    let gameId: Int
    let isFavorite: Bool
}

protocol FavoriteStatusServiceProtocol {
    var statusDidChange: PassthroughSubject<FavoriteStatusChange, Never> { get }
    
    func post(gameId: Int, isFavorite: Bool)
}

class FavoriteStatusService: FavoriteStatusServiceProtocol {
    let statusDidChange = PassthroughSubject<FavoriteStatusChange, Never>()

    func post(gameId: Int, isFavorite: Bool) {
        let change = FavoriteStatusChange(gameId: gameId, isFavorite: isFavorite)
        statusDidChange.send(change)
    }
}
