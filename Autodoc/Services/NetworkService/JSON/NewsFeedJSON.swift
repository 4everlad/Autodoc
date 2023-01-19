//
//  NewsJSON.swift
//  Autodoc
//
//  Created by Dmitry Bakulin on 18.01.2023.
//

import Foundation

struct NewsItemJSON: Codable, Hashable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let publishedDate: String
    let url: String
    let fullUrl: String
    let titleImageUrl: String?
    let categoryType: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: NewsItemJSON, rhs: NewsItemJSON) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id,
             title,
             description,
             publishedDate,
             url,
             fullUrl,
             titleImageUrl = "titleImageUrl",
             categoryType
    }
    
}

struct NewsFeedJSON: Codable {
    let news: [NewsItemJSON]
    let totalCount: Int
    
    enum CodingKeys: String, CodingKey {
        case news, totalCount
    }
}
