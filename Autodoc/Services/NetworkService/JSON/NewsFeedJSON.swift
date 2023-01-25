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
    let urlStr: String
    let fullUrlStr: String
    let titleImageUrlStr: String?
    let categoryType: String
    
    var publishedDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.date(from: publishedDateStr) ?? Date()
    }
    
    var url: URL? {
        return URL(string: urlStr)
    }
    
    var fullUrl: URL? {
        return URL(string: fullUrlStr)
    }
    
    var titleImageUrl: URL? {
        guard let titleImageUrlStr = titleImageUrlStr else { return nil }
        return URL(string: titleImageUrlStr)
    }
    
    enum CodingKeys: String, CodingKey {
        case id,
             title,
             description,
             publishedDateStr = "publishedDate",
             urlStr = "url",
             fullUrlStr = "fullUrl",
             titleImageUrlStr = "titleImageUrl",
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
