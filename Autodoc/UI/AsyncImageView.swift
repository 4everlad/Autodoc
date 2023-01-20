//
//  AsyncImageView.swift
//  Autodoc
//
//  Created by Dmitry Bakulin on 20.01.2023.
//

import UIKit

public class AsyncImageView: UIImageView {
    private let loadingService = ImageLoadingService()
    
    deinit {
        self.cancelLoading()
    }
    
    public func loadImage(_ url: URL) {
        loadingService.loadImage(url: url) { [weak self] data in
            guard let data = data else { return }
            self?.image = UIImage(data: data as Data)
        }
    }
    
    public func cancelLoading() {
        loadingService.cancelLoading()
    }
}

final class ImageLoadingService {
    private let session = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    
    func loadImage(url: URL, completion: @escaping (Data?) -> Void) {
        let newUrl = url as NSURL
        if let data = Cache.images.object(forKey: newUrl) {
            completion(data as Data)
        } else {
            let request = URLRequest(url: url as URL)
            dataTask = session.dataTask(with: request) { data, _, _ in
                guard let data = data else { return }
                Cache.images.setObject(data as NSData, forKey: url as NSURL)
                DispatchQueue.main.async { completion(data) }
            }
            dataTask?.resume()
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
