//
//  RecipeAppTests.swift
//  RecipeAppTests
//
//  Created by Anthony Le on 4/18/25.
//

import XCTest
@testable import RecipeApp

class MockRecipeService: RecipeServiceProtocol {
    var recipesToReturn: [Recipe] = []

    func fetchRecipes(page: Int, limit: Int) async throws -> [Recipe] {
        return recipesToReturn
    }
}

final class RecipeLoaderViewModelTests: XCTestCase {
    
    func testLoadInitialRecipesAddsRecipes() async {
        let mockRecipe = Recipe(id: "1", name: "Mock Recipe", cuisine: "Fusion", photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil)
        let mockService = MockRecipeService()
        mockService.recipesToReturn = [mockRecipe]
        
        let viewModel = RecipeLoaderViewModel(service: mockService)

        await viewModel.loadInitialRecipes()

        XCTAssertEqual(viewModel.recipes.count, 1)
        XCTAssertEqual(viewModel.recipes.first?.name, "Mock Recipe")
    }

    func testLoadMoreRecipesAppendsRecipes() async {
        let mockRecipe1 = Recipe(id: "1", name: "Recipe 1", cuisine: "Asian", photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil)
        let mockRecipe2 = Recipe(id: "2", name: "Recipe 2", cuisine: "Italian", photoURLLarge: nil, photoURLSmall: nil, sourceURL: nil, youtubeURL: nil)

        let mockService = MockRecipeService()
        mockService.recipesToReturn = Array(repeating: mockRecipe1, count: 20)
        let viewModel = RecipeLoaderViewModel(service: mockService)

        await viewModel.loadInitialRecipes()
        
        mockService.recipesToReturn = [mockRecipe2]
        await viewModel.loadMoreRecipes()

        XCTAssertEqual(viewModel.recipes.count, 21)
        XCTAssertEqual(viewModel.recipes.last?.name, "Recipe 2")
    }

    func testLoadMoreDoesNotRunIfCanLoadMoreFalse() async {
        let mockService = MockRecipeService()
        let viewModel = RecipeLoaderViewModel(service: mockService)

        viewModel.canLoadMore = false
        await viewModel.loadMoreRecipes()

        XCTAssertTrue(viewModel.recipes.isEmpty)
    }
}
