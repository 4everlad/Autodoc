//
//  NewsFeedViewModel.swift
//  Autodoc
//
//  Created by Dmitry Bakulin on 17.01.2023.
//

import Foundation

class NewsFeedViewModel: ObservableObject {
    
    @Published private(set) var newsFeed: [NewsItemJSON] = []
    
    private(set) var pageNewsCount: Int = 15
    private(set) var pageCount: Int = 1
    
    private let networkClient = NetworkClient()
    
    func getNews() {
        
        Task {
            do {
                let result = await networkClient.getNewsFeedAsync(pageCount: pageCount, newsCount: pageNewsCount)
                
                guard let news = result else { return }
                
                DispatchQueue.main.async {
                    self.newsFeed.append(contentsOf: news)
                }
            } catch {
                print("async get news error")
            }
        }
        
        
    }
    
}
