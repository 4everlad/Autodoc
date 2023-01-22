//
//  NewsFeedViewModel.swift
//  Autodoc
//
//  Created by Dmitry Bakulin on 17.01.2023.
//

import Foundation
import Combine

class NewsFeedViewModel: ObservableObject {
    
    weak var coordinator : AppCoordinator?
    private let networkClient = NetworkClient()
    
    @Published private(set) var newsFeed: [NewsItem] = []
    var canLoad = true
    
    private(set) var pageNewsCount: Int = 15
    private(set) var page: Int = 1
    private(set) var totalNewsItems: Int = .max
    
    init() {
        getNews(completion: nil)
    }
    
    func getNews(completion: (() -> Void)? = nil) {
        
        guard newsFeed.count <= totalNewsItems else { return }
        guard canLoad == true else { return }
        
        Task() {
            do {
                
                self.canLoad = false
                
                let result = await networkClient.getNewsFeedAsync(pageCount: page, newsCount: pageNewsCount)
                
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
                
                page += 1
                totalNewsItems = feed.totalCount
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
