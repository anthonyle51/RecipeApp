//
//  RecipeDetailView.swift
//  RecipeApp
//
//  Created by Anthony Le on 4/20/25.
//

import SwiftUI
import WebKit

struct RecipeDetailView: View {
    var recipe: Recipe
    @ObservedObject var imageVM: ImageViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isEmbeddable: Bool = false

    
    var body: some View {
        VStack {
            ScrollView {
                ZStack(alignment: .topLeading){
                    if isEmbeddable == true, let youtubeID = recipe.youtubeID {
                        VStack {
                            Rectangle()
                                .frame(height:50)
                                .opacity(0)
                                .edgesIgnoringSafeArea(.all)
                            
                            YouTubeView(videoID: youtubeID)
                                .cornerRadius(20)
                                .padding(5)
                                .frame(height: 300)
                        }
                    } else {
                        if let image = imageVM.image {
                            Image(uiImage: image)
                                .resizable()
                                .cornerRadius(20)
                                .padding(5)
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(8)
                    }
                    .padding()
                }
                
                VStack(alignment: .leading){
                    Text(recipe.cuisine)
                        .font(.caption)
                        .padding(.vertical, 0)
                    
                    Text(recipe.name)
                        .font(.title)
                        .padding(.vertical,0)
                    
                    if let sourceURL = recipe.sourceURL {
                        Button(action: {
                            if let url = URL(string: sourceURL) {
                                UIApplication.shared.open(url)
                            }}) {
                                Text("Visit Site")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color(.systemGray4))
                                    .foregroundColor(.primary)
                                    .cornerRadius(20)
                                
                            }
                    }
                    
                    
                    
                }
                .padding(.horizontal, 15)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear() {
            Task {
                await imageVM.loadImage()
            }
            if let youtubeID = recipe.youtubeID {
                isYouTubeVideoEmbeddable(videoID: youtubeID) { available in
                    DispatchQueue.main.async {
                        self.isEmbeddable = available
                    }
                }
            } else {
                isEmbeddable = false
            }
        }
    }
}


