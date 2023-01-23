//
//  NewsViewModel.swift
//  Autodoc
//
//  Created by Dmitry Bakulin on 21.01.2023.
//

import Foundation
import UIKit

class NewsViewModel {
    
    private let loadingService = ImageLoadingService()
    private(set)var news: NewsItem
    
    init(with news: NewsItem) {
        self.news = news
    }
    
    func getNewsImage() async -> UIImage? {
        guard let imageStr = news.titleImageUrl,
                let url = URL(string: imageStr) else { return nil }
        
        do {
            let result = try await loadingService.loadImage(url: url)
            guard let data = result else { return nil }
            return UIImage(data: data as Data)
        } catch {
            print("no image")
            return nil
        }
        
    }
}
