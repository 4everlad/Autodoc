//
//  NewsFeedViewModel.swift
//  Autodoc
//
//  Created by Dmitry Bakulin on 17.01.2023.
//

import Foundation
import Combine

struct Pagination {
    var itemsCount: Int = 15
    var page: Int = 1
    var totalItems: Int = .max
}

class NewsFeedViewModel: ObservableObject {
    
    weak var coordinator : AppCoordinator?
    private let networkClient = NetworkClient()
    
    @Published private(set) var newsFeed: [NewsItem] = []
    var canLoad = true
    
    var pagination = Pagination()
    
    init() {
        getNews(completion: nil)
    }
    
    func getNews(completion: (() -> Void)? = nil) {
        
        guard newsFeed.count <= pagination.totalItems else { return }
        guard canLoad == true else { return }
        
        Task() {
            do {
                
                self.canLoad = false
                
                let result = await networkClient.getNewsFeedAsync(pageCount: pagination.page, newsCount: pagination.itemsCount)
                
                guard let feed = result else {
                    self.canLoad = true
                    completion?()
                    return
                }
                
                let newsItems: [NewsItem] = feed.news.compactMap {
                    let survey = NewsItem(with: $0)
                    return survey
                }
                
                DispatchQueue.main.async {
                    self.newsFeed.append(contentsOf: newsItems)
                }
                
                pagination.page += 1
                pagination.totalItems = feed.totalCount
                self.canLoad = true
                completion?()
                
            } catch {
                print("async get news error")
                completion?()
            }
        }
        
    }
    
    func showNews(with news: NewsItem) {
        coordinator?.showNews(with: news)
    }
    
}
