//
//  FavoriteView.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

import SwiftUI

struct FavoriteView: View {
    @StateObject private var viewModel: FavoriteViewModel
    
    @EnvironmentObject private var diContainer: DIContainer
    
    init(viewModel: FavoriteViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.favoriteGames.isEmpty {
                    ContentUnavailableView {
                        Label("No Favorites Yet", systemImage: "list.bullet.rectangle.portrait")
                    } description: {
                        Text("Tap the heart icon on a game to add it to your favorites.")
                    }
                } else {
                    List {
                        ForEach(viewModel.favoriteGames) { game in
                            NavigationLink(destination: diContainer.makeDetailView(for: game.id)) {
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
                viewModel.fetchFavorites()
            }
        }
    }
}

// custom row view for the favorites list.
struct FavoriteGameRow: View {
    let game: GameEntity
    var body: some View {
        HStack {
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
        }
        .padding(.vertical, 4)
    }
}
