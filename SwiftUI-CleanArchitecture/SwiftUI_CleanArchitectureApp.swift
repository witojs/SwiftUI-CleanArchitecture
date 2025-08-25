//
//  SwiftUI_CleanArchitectureApp.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

import SwiftUI

@main
struct SwiftUI_CleanArchitectureApp: App {
    @StateObject private var diContainer = DIContainer()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView(viewModel: diContainer.makeHomeViewModel())
                    .tabItem {
                        Label("Games", systemImage: "gamecontroller")
                    }
                
                FavoriteView(viewModel: diContainer.makeFavoriteViewModel())
                    .tabItem {
                        Label("Favorites", systemImage: "heart.fill")
                    }
                
                AboutView()
                    .tabItem {
                        Label("About", systemImage: "person.fill")
                    }
            }
            .environmentObject(diContainer)
        }
    }
}
