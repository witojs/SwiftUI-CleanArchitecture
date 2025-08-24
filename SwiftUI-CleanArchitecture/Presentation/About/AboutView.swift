//
//  AboutView.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 24/08/25.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 150))
                .foregroundColor(.gray)
            
            Text("Dicoding")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("iOS Developer")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("This app was built using SwiftUI with Clean Architecture to demonstrate best practices in modern iOS development.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // A link to a website.
            if let url = URL(string: "https://google.com") {
                Link("Learn More", destination: url)
                    .font(.headline)
            }
        }
        .padding()
    }
}
