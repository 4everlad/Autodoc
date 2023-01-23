//
//  ImageCache.swift
//  Autodoc
//
//  Created by Dmitry Bakulin on 22.01.2023.
//

import Foundation

class ImageCache {
    
    static let shared = ImageCache()
    
    private let cache: NSCache<NSURL, NSData> = {
        let cache = NSCache<NSURL, NSData>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100
        return cache
    }()
    
    func get(forKey key: NSURL) -> NSData? {
        return cache.object(forKey: key)
    }
    
    func save(data: NSData, forKey key: NSURL) {
        cache.setObject(data, forKey: key)
    }
}
