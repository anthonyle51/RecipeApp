//
//  ImageDiskCache.swift
//  RecipeApp
//
//  Created by Anthony Le on 4/18/25.
//
// singleton - global access
import Foundation
import SwiftUI
import CryptoKit

class ImageDiskCache {
    static let shared = ImageDiskCache()

    private init() {}
    
    private let cacheDirectory: URL? = {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        let imageDir = url.appendingPathComponent("ImageCache", isDirectory: true)
        return imageDir
    }()
    
    func createImageCacheDirectory() {
        guard let directory = cacheDirectory else {
            print("Invalid cache directory URL")
            return
        }
        
        if FileManager.default.fileExists(atPath: directory.path) {
            return
        }

        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        } catch {
            print("Failed to create image cache directory: \(error.localizedDescription)")
        }
    }
    
    func saveImage(_ image: Data, forKey key: String) {
        createImageCacheDirectory()
        guard let directory = cacheDirectory else {
            return
        }
        let fileURL = directory.appendingPathComponent(key)
        do {
            try image.write(to: fileURL)
        } catch {
            print("Failed to save image to disk: \(error.localizedDescription)")
        }
    }
    
    func loadImage(forKey key: String) -> Data? {
        guard let directory = cacheDirectory else {
            print("Cache directory is unavailable.")
            return nil
        }

        let fileURL = directory.appendingPathComponent(key)

        do {
            let data = try Data(contentsOf: fileURL)
            return data
        } catch let error as NSError {
            // if its not a file not found error
            if !(error.domain == NSCocoaErrorDomain && error.code == NSFileReadNoSuchFileError) {
                print("Failed to load image: \(error.localizedDescription)")
            }
            return nil
        }
    }
    
    func loadImageAsUIImage(forKey key: String) -> UIImage? {
        guard let data = loadImage(forKey: key) else {
            return nil
        }
        return UIImage(data: data)
    }
    
    func sha256CacheKey(from urlString: String) -> String {
        let data = Data(urlString.utf8)
        let hashed = SHA256.hash(data: data)
        return hashed.map { String(format: "%02x", $0) }.joined()
    }
}
