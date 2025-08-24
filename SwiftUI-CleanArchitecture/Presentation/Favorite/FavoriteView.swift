//
//  FavoriteView.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

import SwiftUI

struct FavoriteView: View {
    // The view owns and observes its ViewModel.
    @StateObject private var viewModel: FavoriteViewModel
    
    // We will inject this from the DI Container later.
    private let diContainer = DIContainer()
    
    init(viewModel: FavoriteViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // If the list is empty, show a helpful message.
                if viewModel.favoriteGames.isEmpty {
                    ContentUnavailableView {
                        Label("No Favorites Yet", systemImage: "list.bullet.rectangle.portrait")
                    } description: {
                        Text("Tap the heart icon on a game to add it to your favorites.")
                    }
                } else {
                    // Display the games in a list.
//                    List(viewModel.favoriteGames) { game in
//                        // Wrap each row in a NavigationLink to go to the detail view.
//                        NavigationLink(destination: diContainer.makeDetailView(for: game.id)) {
//                            FavoriteGameRow(game: game) {
//                                // This is the action closure for the remove button.
//                                // It calls the ViewModel's remove function.
//                                viewModel.removeFavorite(game: game)
//                            }
//                        }
//                    }
                    List {
                        ForEach(viewModel.favoriteGames) { game in
                            NavigationLink(destination: diContainer.makeDetailView(for: game.id)) {
                                // We can now reuse the GameRow from the home screen.
                                // The custom button is no longer needed.
                                FavoriteGameRow(game: game)
                            }
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: viewModel.removeFavorite)
                    }
                }
            }
            .navigationTitle("Favorites")
            .onAppear {
                // Every time the view appears, fetch the latest list of favorites.
                // This ensures the list is up-to-date if a favorite was removed
                // from the detail screen.
                viewModel.fetchFavorites()
            }
        }
    }
}

// A custom row view for the favorites list.
struct FavoriteGameRow: View {
    let game: GameEntity
    // A closure that will be executed when the favorite button is tapped.
//    let onRemove: () -> Void
    
    var body: some View {
        HStack {
            // A simplified version of the GameRow from HomeView.
            AsyncImage(url: URL(string: game.backgroundImage)) { image in
                image.resizable()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 100, height: 65)
            .cornerRadius(6)
            
            VStack(alignment: .leading) {
                Text(game.name).font(.headline)
                Text("Rating: \(String(format: "%.2f", game.rating))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
//            Spacer()
            
            // The remove button.
//            Button(action: onRemove) {
//                Image(systemName: "heart.fill")
//                    .foregroundColor(.red)
//                    .imageScale(.large)
//            }
//            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}
