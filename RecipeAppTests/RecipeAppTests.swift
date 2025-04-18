//
//  RecipeAppTests.swift
//  RecipeAppTests
//
//  Created by Anthony Le on 4/18/25.
//

import XCTest
@testable import RecipeApp

class RecipeAppTests: XCTestCase {
    let viewModel = RecipeViewModel()

    func testFetchRecipes() async throws {
        let recipes = try await viewModel.fetchRecipes()
        
        print(recipes)
        XCTAssertFalse(recipes.isEmpty)
        XCTAssertNotNil(recipes.first?.name)
    }
}
