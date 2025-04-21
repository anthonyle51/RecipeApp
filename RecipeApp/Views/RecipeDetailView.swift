//
//  RecipeDetailView.swift
//  RecipeApp
//
//  Created by Anthony Le on 4/20/25.
//

import SwiftUI

struct RecipeDetailView: View {
    var recipe: Recipe
    @ObservedObject var imageVM: ImageViewModel
    
    var body: some View {
        VStack {
            ScrollView {
                if let image = imageVM.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .onAppear() {
            Task {
                await imageVM.loadImage()
            }
        }
    }
}
