//
//  FeedView.swift
//  RecipeApp
//
//  Created by Anthony Le on 4/18/25.
//

import SwiftUI

struct FeedView: View {
    @ObservedObject var recipeLoaderVM: RecipeLoaderViewModel
    
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
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(recipeLoaderVM.recipes) { recipe in
                                NavigationLink(value: recipe) {
                                    if let photoURL = recipe.highestResPhotoURL {
                                        feedItemView(recipe: recipe, imageVM: ImageViewModel(imageURLString: photoURL))
                                    }
                                }
                                .onAppear {
                                    if recipe == recipeLoaderVM.recipes.last {
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
                    .cornerRadius(5)
                    .aspectRatio(contentMode: .fit)
            }
            
            GeometryReader { geometry in
                Text(recipe.name)
                    .foregroundColor(.primary)
                    .font(.caption)
                    .frame(maxWidth: geometry.size.width * 0.8, alignment: .leading)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .frame(height: 20)
        }
        .onAppear() {
            Task {
                await imageVM.loadImage()
            }
        }
    }
}



