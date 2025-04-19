//
//  ImageViewModel.swift
//  RecipeApp
//
//  Created by Anthony Le on 4/18/25.
//
import Foundation
import SwiftUI

class ImageViewModel: ObservableObject {
    @Published var image: UIImage?
    
    let imageURLString: String
    let imageURL: URL?
    let key: String

    init(imageURLString: String) {
        self.imageURLString = imageURLString
        self.imageURL = URL(string: imageURLString)
        self.key = ImageDiskCache.shared.sha256CacheKey(from: imageURLString)
    }
    
    func loadImage() {
        // Load from cache
        if let image = ImageDiskCache.shared.loadImageAsUIImage(forKey: key) {
            self.image = image
            return
        }

        // Load from CDN and save to Cache
        guard let url = imageURL else {
            print("imageURL invalid")
            return
        }

        DispatchQueue.global(qos: .background).async {
            guard let imageData = try? Data(contentsOf: url) else {
                print("Failure to load data from URL")
                return
            }
            
            guard let image = UIImage(data: imageData) else {
                print("failure to load image from data")
                return
            }
            
            ImageDiskCache.shared.saveImage(imageData, forKey: self.key)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
}
