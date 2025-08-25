//
//  HomeView.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @EnvironmentObject private var diContainer: DIContainer
    
    private let gridColumns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Main content view
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // Feature Carousel Section
                        if !viewModel.featuredGames.isEmpty {
                            Text("Featured Games")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(viewModel.featuredGames) { game in
                                        NavigationLink(destination: diContainer.makeDetailView(for: game.id)) {
                                            FeaturedCardView(game: game)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // --- ALL GAMES GRID SECTION ---
                        if !viewModel.allGames.isEmpty {
                            Text("All Games")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: gridColumns, spacing: 20) {
                                ForEach(viewModel.allGames) { game in
                                    NavigationLink(destination: diContainer.makeDetailView(for: game.id)) {
                                        GameCardView(game: game)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
                .overlay {
                    if viewModel.isLoading {
                        ProgressView().tint(.white)
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage).foregroundColor(.white)
                    }
                }
            }
            .navigationTitle("Game Catalog")
            .searchable(text: $viewModel.searchText)
            .onAppear {
                if viewModel.games.isEmpty {
                    viewModel.fetchGames(query: "")
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

// Card for the top "Featured" carousel
struct FeaturedCardView: View {
    let game: GameEntity
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background Image
            AsyncImage(url: URL(string: game.backgroundImage)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.4)
            }
            .frame(width: 320, height: 200)
            
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.8)]),
                startPoint: .center,
                endPoint: .bottom
            )
            
            // Game Info Text
            VStack(alignment: .leading) {
                Text(game.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Rating: \(String(format: "%.2f", game.rating))")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(radius: 8)
    }
}

// Card for the main "All Games" grid
struct GameCardView: View {
    let game: GameEntity
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: URL(string: game.backgroundImage)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            } placeholder: {
                Color.gray.opacity(0.4)
            }
            
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                startPoint: .top,
                endPoint: .bottom
            )
            
            Text(game.name)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .aspectRatio(3/4, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 5)
    }
}
