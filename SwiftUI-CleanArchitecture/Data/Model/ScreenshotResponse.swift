//
//  ScreenshotResponse.swift
//  SwiftUI-CleanArchitecture
//
//  Created by Wito Irawan on 25/08/25.
//

struct ScreenshotsResponse: Codable {
    let results: [Screenshot]
}

struct Screenshot: Codable, Identifiable {
    let id: Int
    let image: String 
}
