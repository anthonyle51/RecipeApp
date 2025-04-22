//
//  ImageDiskCacheTests.swift
//  RecipeApp
//
//  Created by Anthony Le on 4/22/25.
//

import XCTest
@testable import RecipeApp

final class ImageDiskCacheTests: XCTestCase {

    func testCacheKeyHashingIsDeterministic() {
        let url = "https://example.com/image.jpg"
        let key1 = ImageDiskCache.shared.sha256CacheKey(from: url)
        let key2 = ImageDiskCache.shared.sha256CacheKey(from: url)
        
        XCTAssertEqual(key1, key2, "Hashing should be consistent")
    }

    func testSaveAndLoadImageData() {
        let key = "test_raw_image"
        let originalData = "Hello, image!".data(using: .utf8)!
        
        ImageDiskCache.shared.saveImage(originalData, forKey: key)
        let loadedData = ImageDiskCache.shared.loadImage(forKey: key)

        XCTAssertEqual(loadedData, originalData, "Saved and loaded data should match")
    }

    func testSaveAndLoadUIImage() {
        let key = "test_uiimage"
        guard let image = UIImage(systemName: "star.fill"),
              let imageData = image.pngData() else {
            XCTFail("Failed to create test image")
            return
        }

        ImageDiskCache.shared.saveImage(imageData, forKey: key)
        let loadedImage = ImageDiskCache.shared.loadImageAsUIImage(forKey: key)

        XCTAssertNotNil(loadedImage, "Should load UIImage from saved image data")
    }

    func testMissingImageReturnsNil() {
        let key = "nonexistent_image"
        let data = ImageDiskCache.shared.loadImage(forKey: key)
        let image = ImageDiskCache.shared.loadImageAsUIImage(forKey: key)

        XCTAssertNil(data, "No data should be returned for a missing file")
        XCTAssertNil(image, "No image should be returned for a missing file")
    }
}
