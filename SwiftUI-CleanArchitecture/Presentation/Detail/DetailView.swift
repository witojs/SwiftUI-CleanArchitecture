//
//  DetailView.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

import SwiftUI

struct AsyncImageContainer: View {
    let url: String
    let size: CGSize
    let cornerRadius: CGFloat
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image.resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: size.height)
                .clipped()
        } placeholder: {
            Color.gray.opacity(0.4)
                .frame(width: size.width, height: size.height)
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

struct DetailView: View {
    @StateObject private var viewModel: DetailViewModel

    init(viewModel: DetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            if let game = viewModel.game {
                AsyncImageContainer(url: game.backgroundImage, size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), cornerRadius: 0)
                    .blur(radius: 20)
                    .opacity(0.3)
                    .ignoresSafeArea()
            } else {
                Color.black.ignoresSafeArea()
            }
            
            ScrollView {
                if viewModel.isLoading {
                    ProgressView().tint(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else if let game = viewModel.game {
                    VStack(alignment: .leading, spacing: 24) {
                        HeaderView(game: game)
                        StatsView(game: game)
                            .padding(.horizontal)
                        GenreTagsView(genres: game.genres)
                            .padding(.horizontal)
                        ExpandableTextView(text: game.description)
                            .padding(.horizontal)
                        ScreenshotGalleryView(screenshots: viewModel.screenshots)
                        VStack(alignment: .leading, spacing: 16) {
                            InfoRow(title: "Developers", content: game.developers.joined(separator: ", "))
                            InfoRow(title: "Platforms", content: game.platforms.joined(separator: ", "))
                            InfoRow(title: "Released", content: game.released)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 24)
                } else {
                    Text("Game details not available.")
                        .foregroundColor(.white)
                }
            }
        }
        .onAppear {
            if viewModel.game == nil {
                viewModel.loadGameDetails()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) { Color.clear }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: viewModel.toggleFavorite) {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isFavorite ? .red : .white)
                }
            }
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Material.ultraThin, for: .navigationBar)
    }
}

struct HeaderView: View {
    let game: GameEntity
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImageContainer(url: game.backgroundImage, size: CGSize(width: UIScreen.main.bounds.width, height: 300), cornerRadius: 0)
            
            LinearGradient(colors: [.clear, .black.opacity(0.8)], startPoint: .top, endPoint: .bottom)
            
            Text(game.name)
                .font(.largeTitle).fontWeight(.black)
                .foregroundColor(.white)
                .padding()
        }
        .frame(height: 300)
    }
}

struct StatsView: View {
    let game: GameEntity
    var body: some View {
        HStack {
            Spacer()
            StatPill(title: "Metascore", value: "\(game.metacritic)", color: .green)
            Spacer()
            StatPill(title: "User Rating", value: String(format: "%.2f", game.rating), color: .yellow)
            Spacer()
        }
        .padding(.vertical)
        .background(Color.black.opacity(0.35))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

struct StatPill: View {
    let title: String
    let value: String
    let color: Color
    var body: some View {
        VStack {
            Text(value)
                .font(.title).fontWeight(.bold)
                .foregroundColor(color)
            Text(title)
                .font(.caption).fontWeight(.semibold)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }
}

struct GenreTagsView: View {
    let genres: [String]
    var body: some View {
        VStack(alignment: .leading) {
            Text("Genres").font(.headline).foregroundColor(.black)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(genres, id: \.self) { genre in
                        Text(genre)
                            .font(.caption)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.white.opacity(0.15))
                            .clipShape(Capsule())
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

struct ScreenshotGalleryView: View {
    let screenshots: [ScreenshotEntity]
    var body: some View {
        VStack(alignment: .leading) {
            if !screenshots.isEmpty {
                Text("Screenshots").font(.headline).foregroundColor(.black).padding(.horizontal)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(screenshots) { screenshot in
                            AsyncImage(url: URL(string: screenshot.imageURL)) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 250, height: 140)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.4)).frame(width: 250, height: 140)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct ExpandableTextView: View {
    let text: String
    @State private var isExpanded = false
    private let lineLimit = 5
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("About").font(.headline).foregroundColor(.black)
            Text(text)
                .font(.body).foregroundColor(.secondary)
                .lineLimit(isExpanded ? nil : lineLimit)
            
            Button(action: { withAnimation { isExpanded.toggle() } }) {
                Text(isExpanded ? "Show Less" : "Read More")
                    .foregroundColor(.accentColor)
                    .fontWeight(.bold)
            }
        }
    }
}

struct InfoRow: View {
    let title: String
    let content: String
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.headline).foregroundColor(.black)
            Text(content).font(.body).foregroundColor(.secondary)
        }
    }
}
