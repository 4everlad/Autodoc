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
    
    public func loadImage(_ url: URL, completion: ((Bool) -> Void)? = nil) {
        Task {
            do {
                let result = try await loadingService.loadImage(url: url)
                guard let data = result else {
                    completion?(false)
                    return
                }
                
                let image = UIImage(data: data as Data)
                DispatchQueue.main.async {
                    self.image = image
                }
                completion?(true)
            }
            catch {
                print("async load image error")
                completion?(false)
            }
        }
    }
    
    public func loadImageAsync(_ url: URL) async -> Bool {
        do {
            let result = try await loadingService.loadImage(url: url)
            guard let data = result else {
                return false
            }
            
            let image = UIImage(data: data as Data)
            DispatchQueue.main.async {
                self.image = image
            }
            
            return true
        }
        catch {
            print("async load image error")
            return false
        }
    }
    
    public func cancelLoading() {
        loadingService.cancelLoading()
    }
}
