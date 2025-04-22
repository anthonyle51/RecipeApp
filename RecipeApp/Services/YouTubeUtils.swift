//
//  YouTubeUtils.swift
//  RecipeApp
//
//  Created by Anthony Le on 4/22/25.
//
import Foundation

func isYouTubeVideoEmbeddable(videoID: String, completion: @escaping (Bool) -> Void) {
    let oembedURL = "https://www.youtube.com/oembed?url=https://www.youtube.com/watch?v=\(videoID)&format=json"

    guard let url = URL(string: oembedURL) else {
        completion(false)
        return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
        if let httpResponse = response as? HTTPURLResponse {
            completion(httpResponse.statusCode == 200)
        } else {
            completion(false)
        }
    }.resume()
}
