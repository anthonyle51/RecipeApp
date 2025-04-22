//
//  Recipe.swift
//  RecipeApp
//
//  Created by Anthony Le on 4/18/25.
//

import Foundation

struct RecipeListResponse: Codable {
    let recipes: [Recipe]
}

struct Recipe: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let cuisine: String
    let photoURLLarge: String?
    let photoURLSmall: String?
    let sourceURL: String?
    let youtubeURL: String?

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case cuisine
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case youtubeURL = "youtube_url"
    }
    
    var highestResPhotoURL: String? {
        return photoURLLarge ?? photoURLSmall
    }

    var lowestResPhotoURL: String? {
        return photoURLSmall ?? photoURLLarge
    }
    
    var youtubeID: String? {
        guard let url = youtubeURL,
              let components = URLComponents(string: url),
              components.host?.contains("youtube.com") == true,
              let queryItems = components.queryItems else {
            return nil
        }
        return queryItems.first(where: { $0.name == "v" })?.value
    }
}

//    Example Data
//    {
//        "cuisine": "Malaysian",
//        "name": "Apam Balik",
//        "photo_url_large": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg",
//        "photo_url_small": "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg",
//        "source_url": "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ",
//        "uuid": "0c6ca6e7-e32a-4053-b824-1dbf749910d8",
//        "youtube_url": "https://www.youtube.com/watch?v=6R8ffRRJcrg"
//    }
