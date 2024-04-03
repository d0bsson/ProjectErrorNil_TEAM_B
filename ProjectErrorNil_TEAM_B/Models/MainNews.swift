//
//  News.swift
//  ProjectErrorNil_TEAM_B
//
//  Created by Мадина Валиева on 31.03.2024.
//

import Foundation

struct MainNews: Decodable {
    let totalResults: Int
    let articles: [NewsItem]
}
struct NewsItem: Decodable {
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String? 
}
