//
//  SwiftUI_CleanArchitectureApp.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

import SwiftUI

@main
struct SwiftUI_CleanArchitectureApp: App {
    private let diContainer = DIContainer()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                // --- Tab 1: Home ---
                HomeView(viewModel: diContainer.makeHomeViewModel())
                    .tabItem {
                        Label("Games", systemImage: "gamecontroller")
                    }
                
                // --- Tab 2: Favorites ---
                FavoriteView(viewModel: diContainer.makeFavoriteViewModel())
                    .tabItem {
                        Label("Favorites", systemImage: "heart.fill")
                    }
                
                // --- Tab 3: About ---
                AboutView()
                    .tabItem {
                        Label("About", systemImage: "person.fill")
                    }
            }
        }
    }
}
