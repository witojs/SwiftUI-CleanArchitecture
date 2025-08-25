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
            
            Text("Wito Irawan")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("iOS Developer")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Submission 1 iOS Expert - Dicoding")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}
