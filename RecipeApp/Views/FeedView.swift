//
//  FeedView.swift
//  RecipeApp
//
//  Created by Anthony Le on 4/18/25.
//

import SwiftUI

struct FeedView: View {
    @ObservedObject var recipeVM: RecipeViewModel

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(recipeVM.recipes) { recipe in
                    if let photoURLSmall = recipe.photoURLSmall {
                        feedItemView(imageVM: ImageViewModel(imageURLString: photoURLSmall), recipe: recipe)
                    }
                }
            }
            .padding()
        }
    }
}

struct feedItemView: View {
    @StateObject var imageVM: ImageViewModel
    var recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading) {
            if let image = imageVM.image {
                Image(uiImage: image)
                    .resizable()
            }
            
            Text(recipe.name)
                .font(.caption)
        }
        .onAppear() {
            imageVM.loadImage()
        }
    }
}

