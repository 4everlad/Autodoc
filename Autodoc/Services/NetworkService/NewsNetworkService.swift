//
//  NewsNetworkService.swift
//  Autodoc
//
//  Created by Dmitry Bakulin on 18.01.2023.
//

import Foundation

protocol NewsNetworkService {
    func getNewsFeedAsync(pageCount: Int, newsCount: Int) async -> [NewsItemJSON]?
}

extension NetworkClient: NewsNetworkService {
    func getNewsFeedAsync(pageCount: Int, newsCount: Int) async -> [NewsItemJSON]? {
        let endpoint = "news/\(pageCount)/\(newsCount)"
        
        let result = try await requestAsync(path: endpoint) as Result<NewsFeedJSON, Error>
        
        switch result {
        case .success(let data):
            return data.news
        case .failure(_):
            return nil
        }
    }
    
}
