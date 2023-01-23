//
//  NewsNetworkService.swift
//  Autodoc
//
//  Created by Dmitry Bakulin on 18.01.2023.
//

import Foundation

protocol NewsNetworkService {
    func getNewsFeedAsync(pageCount: Int, newsCount: Int) async -> NewsFeedJSON?
}

extension NetworkClient: NewsNetworkService {
    func getNewsFeedAsync(pageCount: Int, newsCount: Int) async -> NewsFeedJSON? {
        let endpoint = "news/\(pageCount)/\(newsCount)"
        
        let result = await requestAsync(path: endpoint) as Result<NewsFeedJSON, Error>
        
        switch result {
        case .success(let data):
            return data
        case .failure(_):
            return nil
        }
    }
    
}
