//
//  RecipeViewModel.swift
//  RecipeApp
//
//  Created by Anthony Le on 4/18/25.
//
import Foundation

class RecipeLoaderViewModel: ObservableObject {
    @Published var recipes: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var isStartUp: Bool = false

    private let service = RecipeService()
    private var page = 0
    private let limit = 20
    private var canLoadMore = true
    
    // keep data in VM
    @MainActor
    func loadInitialRecipes() async {
        self.isStartUp = true
        self.page = 0
        self.canLoadMore = true
        self.recipes = []
        await loadMoreRecipes()
        self.isStartUp = false
    }
    
    // Pretend it took longer to get data
    @MainActor
    func loadInitialRecipesRefresher() async {
        try? await Task.sleep(for: .seconds(2))
        self.page = 0
        self.canLoadMore = true
        self.recipes = []
        await loadMoreRecipes()
    }


    @MainActor
    func loadMoreRecipes() async {
        guard !isLoading && canLoadMore else { return }
        isLoading = true

        do {
            let newRecipes = try await service.fetchRecipes(page: page, limit: limit)
            self.recipes.append(contentsOf: newRecipes)
            if newRecipes.count < limit {
                self.canLoadMore = false
            } else {
                self.page += 1
            }
        } catch {
            print("Error loading more recipes:", error)
        }

        isLoading = false
    }
}
