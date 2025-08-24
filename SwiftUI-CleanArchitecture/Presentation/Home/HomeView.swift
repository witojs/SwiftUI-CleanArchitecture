//
//  HomeView.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    private let diContainer = DIContainer()
    
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
                // A darker, more "gamey" background gradient
//                LinearGradient(
//                    gradient: Gradient(colors: [Color(red: 0.1, green: 0.1, blue: 0.2), .black]),
//                    startPoint: .top,
//                    endPoint: .bottom
//                )
//                .ignoresSafeArea()
                
                // Main content view
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        // --- FEATURED CAROUSEL SECTION ---
                        if !viewModel.featuredGames.isEmpty {
                            Text("Featured Games")
                                .font(.title2)
                                .fontWeight(.bold)
//                                .foregroundColor(.white)
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
//                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            // Use LazyVGrid for a performance-efficient grid
                            LazyVGrid(columns: gridColumns, spacing: 20) {
                                ForEach(viewModel.allGames) { game in
                                    NavigationLink(destination: DIContainer().makeDetailView(for: game.id)) {
                                        GameCardView(game: game)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
                // Handle loading and error states
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
            // Customize navigation bar for dark theme
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

// --- CUSTOM CARD VIEWS ---

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
            
            // Gradient overlay for text readability
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
            // Background Image now fills the available space defined by the parent ZStack
            AsyncImage(url: URL(string: game.backgroundImage)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    // Let the image fill the entire space of the card
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            } placeholder: {
                Color.gray.opacity(0.4)
            }
            
            // Gradient overlay
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.7)]),
                startPoint: .top,
                endPoint: .bottom
            )
            
            // Game Name (shorter, for the smaller card)
            Text(game.name)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        // 1. Give the CARD ITSELF a defined aspect ratio (e.g., portrait 3:4)
        .aspectRatio(3/4, contentMode: .fit)
        // 2. Clip the entire card, which now properly contains the image.
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(radius: 5)
    }
}
