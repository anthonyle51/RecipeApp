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
    
    @MainActor
    func loadImage() async {
        // Load from cache
        if let imageFromCache = ImageDiskCache.shared.loadImageAsUIImage(forKey: key) {
            self.image = imageFromCache
            return
        }

        // Load from CDN and save to Cache
        guard let url = imageURL else {
            print("imageURL invalid")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            guard let imageFromCDN = UIImage(data: data) else {
                print("failure to load image from data")
                return
            }

            ImageDiskCache.shared.saveImage(data, forKey: key)
            self.image = imageFromCDN
        } catch {
            print("Failed to fetch image: \(error.localizedDescription)")
        }
    }
    
}
