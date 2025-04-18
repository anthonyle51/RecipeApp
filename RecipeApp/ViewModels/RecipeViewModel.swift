//
//  RecipeViewModel.swift
//  RecipeApp
//
//  Created by Anthony Le on 4/18/25.
//
import Foundation

class RecipeViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []

    func fetchRecipes() async throws -> [Recipe] {
        let url = URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json")!
        
        // see if there is bad URL
        let (data, response) = try await URLSession.shared.data(from: url)

        let decoded = try JSONDecoder().decode(RecipeListResponse.self, from: data)
        return decoded.recipes
    }
    
    
    // keep data in VM
    func loadRecipes() async {
        do {
            self.recipes = try await fetchRecipes()
        } catch {
            print("Error fetching recipes:", error)
        }
    }
}
