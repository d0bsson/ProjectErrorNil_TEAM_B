//
//  News.swift
//  ProjectErrorNil_TEAM_B
//
//  Created by Мадина Валиева on 31.03.2024.
//

import Foundation

protocol NewsItemRepresentable {
    var title: String? { get }
    var description: String? { get }
    var url: String? { get }
    var urlToImage: String? { get }
    var publishedAt: String? { get }
    var content: String? { get }
}
struct MainNews: Decodable {
    let totalResults: Int
    let articles: [NewsItem]
}
struct NewsItem: Decodable, NewsItemRepresentable {
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String? 
}
