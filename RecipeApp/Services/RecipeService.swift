//
//  RecipeService.swift
//  RecipeApp
//
//  Created by Anthony Le on 4/19/25.
//

import Foundation

protocol RecipeServiceProtocol {
    func fetchRecipes(page: Int, limit: Int) async throws -> [Recipe]
}

class RecipeService: RecipeServiceProtocol {
    func fetchRecipes(page: Int, limit: Int) async throws -> [Recipe] {
        let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(RecipeListResponse.self, from: data)
            
            let start = page * limit
            let end = min(start + limit, decoded.recipes.count)
            if start >= decoded.recipes.count { return [] }
            return Array(decoded.recipes[start..<end])
        } catch DecodingError.keyNotFound {
            print("malformed data")
            return []
        } catch {
            print("Error: \(error)")
            throw error
        }
    }
}
