//
//  RecipeViewModel.swift
//  RecipeApp
//
//  Created by Anthony Le on 4/18/25.
//
import Foundation

class RecipeLoaderViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []

    private let service = RecipeService()
    
    // keep data in VM
    @MainActor
    func loadRecipes() async {
        print("ok")
        do {
            self.recipes = try await service.fetchRecipes()
        } catch {
            print("Error fetching recipes:", error)
        }
    }
}
