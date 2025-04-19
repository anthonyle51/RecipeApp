//
//  RecipeService.swift
//  RecipeApp
//
//  Created by Anthony Le on 4/19/25.
//

import Foundation

class RecipeService {
    func fetchRecipes() async throws -> [Recipe] {
        let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
        
        // see if there is bad URL
        let (data, _) = try await URLSession.shared.data(from: url)

        let decoded = try JSONDecoder().decode(RecipeListResponse.self, from: data)
        return decoded.recipes
    }
}
