//
//  NewsViewModel.swift
//  Autodoc
//
//  Created by Dmitry Bakulin on 21.01.2023.
//

import Foundation

class NewsViewModel {
    
    private var news: NewsItemJSON?
    
    init(with news: NewsItemJSON) {
        self.news = news
    }
}
