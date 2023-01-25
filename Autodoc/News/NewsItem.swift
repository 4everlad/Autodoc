//
//  NewsItem.swift
//  Autodoc
//
//  Created by Dmitry Bakulin on 22.01.2023.
//

import Foundation

struct NewsItem: Identifiable, Hashable {
    let id: Int
    let title: String
    let description: String
    var publishedDate: Date
    let url: URL?
    let fullUrl: URL?
    let titleImageUrl: URL?
    let categoryType: String
    
    var publishedDateStr: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.string(from: publishedDate)
    }
    
    init(with json: NewsItemJSON) {
        self.id = json.id
        self.title = json.title
        self.description = json.description
        self.publishedDate = json.publishedDate
        self.url = json.url
        self.fullUrl = json.fullUrl
        self.titleImageUrl = json.titleImageUrl
        self.categoryType = json.categoryType
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: NewsItem, rhs: NewsItem) -> Bool {
        return lhs.id == rhs.id
    }
}
