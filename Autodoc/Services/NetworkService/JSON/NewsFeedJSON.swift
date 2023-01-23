//
//  NewsJSON.swift
//  Autodoc
//
//  Created by Dmitry Bakulin on 18.01.2023.
//

import Foundation

struct NewsItemJSON: Codable {
    let id: Int
    let title: String
    let description: String
    let publishedDateStr: String
    let url: String
    let fullUrl: String
    let titleImageUrl: String?
    let categoryType: String
    
    var publishedDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: publishedDateStr) ?? Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case id,
             title,
             description,
             publishedDateStr = "publishedDate",
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
