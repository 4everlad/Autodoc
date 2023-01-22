//
//  AsyncImageView.swift
//  Autodoc
//
//  Created by Dmitry Bakulin on 20.01.2023.
//

import UIKit

public class AsyncImageView: UIImageView {
    private let loadingService = ImageLoadingService()
    
    public override var image: UIImage? {
        didSet {
            super.image = image
        }
    }
    
    deinit {
        self.cancelLoading()
    }
    
    public func loadImage(_ url: URL, completion: ((Bool) -> Void)? = nil) {
        Task {
            do {
                let result = try await loadingService.loadImage(url: url)
                guard let data = result else {
                    completion?(false)
                    return
                }
                self.image = UIImage(data: data as Data)
                completion?(true)
            }
            catch {
                print("async load image error")
                completion?(false)
            }
        }
    }
    
    public func loadImageASync(_ url: URL) {
        Task {
            do {
                let result = try await loadingService.loadImage(url: url)
                guard let data = result else {
                    return
                }
                self.image = UIImage(data: data as Data)
            }
            catch {
                print("async load image error")
            }
        }
    }
    
    public func cancelLoading() {
        loadingService.cancelLoading()
    }
}

final class ImageLoadingService {
    private let session = URLSession(configuration: .default)
    private var dataTask: Task<Data, Error>?
    
    func loadImage(url: URL) async throws -> Data? {
        let newUrl = url as NSURL
        if let data = Cache.images.object(forKey: newUrl) {
            return data as Data
        } else {
            dataTask = Task {
                let(data, _) = try await session.data(from: url, delegate: nil)
                Cache.images.setObject(data as NSData, forKey: url as NSURL)
                return data
            }
            
            return try await dataTask?.value
        }
    }
    
    func cancelLoading() {
        dataTask?.cancel()
    }
}

final class Cache {
    static let images: NSCache<NSURL, NSData> = {
        let cache = NSCache<NSURL, NSData>()
        cache.countLimit = 100 // items limit
        cache.totalCostLimit = 1024 * 1024 * 100 // memory limit
        return cache
    }()
}
