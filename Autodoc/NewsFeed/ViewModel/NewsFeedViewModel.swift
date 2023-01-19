//
//  NewsFeedViewModel.swift
//  Autodoc
//
//  Created by Dmitry Bakulin on 17.01.2023.
//

import Foundation

class NewsFeedViewModel: ObservableObject {
    private let networkClient = NetworkClient()
    
    @Published private(set) var newsFeed: [NewsItemJSON] = []
    var canLoad = true
    
    private(set) var pageNewsCount: Int = 15
    private(set) var page: Int = 1
    private(set) var totalNewsItems: Int = .max
    
    func getNews() {
        
        guard newsFeed.count <= totalNewsItems else { return }
        guard canLoad == true else { return }
        
        Task {
            do {
                
                canLoad = false
                let result = await networkClient.getNewsFeedAsync(pageCount: page, newsCount: pageNewsCount)
                
                guard let feed = result else { return }
                
                DispatchQueue.main.async {
                    self.newsFeed.append(contentsOf: feed.news)
                }
                
                page += 1
                totalNewsItems = feed.totalCount
                canLoad = true
                
            } catch {
                print("async get news error")
            }
        }
        
        
    }
    
}
