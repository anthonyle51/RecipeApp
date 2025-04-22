//
//  FeedView.swift
//  RecipeApp
//
//  Created by Anthony Le on 4/18/25.
//

import SwiftUI

struct FeedView: View {
    @StateObject var recipeLoaderVM = RecipeLoaderViewModel()

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if recipeLoaderVM.recipes.isEmpty && !recipeLoaderVM.isStartUp {
                        Spacer()
                        VStack{
                            Text("No recipes at the moment...")
                        }
                        Spacer()
                    } else {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(recipeLoaderVM.recipes) { recipe in
                                NavigationLink(value: recipe) {
                                    if let photoURL = recipe.highestResPhotoURL {
                                        feedItemView(recipe: recipe, imageVM: ImageViewModel(imageURLString: photoURL))
                                    }
                                }
                                .onAppear {
                                    if recipe == recipeLoaderVM.recipes.last && recipeLoaderVM.canLoadMore {
                                        Task {
                                            await recipeLoaderVM.loadMoreRecipes()
                                        }
                                    }
                                }
                                
                                if recipeLoaderVM.isLoading {
                                    ProgressView().padding()
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .onAppear() {
                Task {
                    await recipeLoaderVM.loadInitialRecipes()
                }
            }
            .refreshable {
                await recipeLoaderVM.loadInitialRecipesRefresher()

            }
            .navigationDestination(for: Recipe.self) { recipe in
                if let photoURL = recipe.highestResPhotoURL {
                    RecipeDetailView(recipe: recipe, imageVM: ImageViewModel(imageURLString: photoURL))
                }
            }
        }
    }
}

struct feedItemView: View {
    var recipe: Recipe
    @StateObject var imageVM: ImageViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            if let image = imageVM.image {
                Image(uiImage: image)
                    .resizable()
                    .cornerRadius(10)
                    .aspectRatio(contentMode: .fit)
                    .padding(.vertical, 0)
            }
            
            Text(recipe.name)
                .foregroundColor(.primary)
                .font(.caption)
                .lineLimit(1)
                .truncationMode(.tail)
                .padding(.vertical, 0)
                
            
            Text(recipe.cuisine)
                .foregroundColor(.primary)
                .font(.caption)
                .fontWeight(.thin)
                .lineLimit(1)
                .padding(.vertical, 0)

        }
        .onAppear() {
            Task {
                await imageVM.loadImage()
            }
        }
    }
}



