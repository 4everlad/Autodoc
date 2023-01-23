//
//  ImageLoadingService.swift
//  Autodoc
//
//  Created by Dmitry Bakulin on 22.01.2023.
//

import Foundation

final class ImageLoadingService {
    private let session = URLSession(configuration: .default)
    private var dataTask: Task<Data, Error>?
    private let imageCache = ImageCache.shared
    
    func loadImage(url: URL) async throws -> Data? {
        let newUrl = url as NSURL
        if let data = imageCache.get(forKey: newUrl) {
            return data as Data
        } else {
            dataTask = Task {
                let(data, _) = try await session.data(from: url, delegate: nil)
                imageCache.save(data: data as NSData, forKey: url as NSURL)
                return data
            }
            
            return try await dataTask?.value
        }
    }
    
    func cancelLoading() {
        dataTask?.cancel()
    }
}
