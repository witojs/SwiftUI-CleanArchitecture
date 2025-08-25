//
//  FavoriteStatusService.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 25/08/25.
//
import Combine

// A simple data structure to describe the change event.
struct FavoriteStatusChange {
    let gameId: Int
    let isFavorite: Bool
}

// A protocol for our service, which is good for testing.
protocol FavoriteStatusServiceProtocol {
    // A publisher that views can subscribe to.
    var statusDidChange: PassthroughSubject<FavoriteStatusChange, Never> { get }
    
    // A function to broadcast a change.
    func post(gameId: Int, isFavorite: Bool)
}

// The concrete implementation of the service.
class FavoriteStatusService: FavoriteStatusServiceProtocol {
    // A PassthroughSubject is a simple publisher that broadcasts values to subscribers.
    let statusDidChange = PassthroughSubject<FavoriteStatusChange, Never>()

    func post(gameId: Int, isFavorite: Bool) {
        let change = FavoriteStatusChange(gameId: gameId, isFavorite: isFavorite)
        // Send the change to all active subscribers.
        statusDidChange.send(change)
    }
}
