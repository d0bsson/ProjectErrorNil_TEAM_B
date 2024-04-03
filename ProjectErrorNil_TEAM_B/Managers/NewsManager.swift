//
//  NewsManager.swift
//  ProjectErrorNil_TEAM_B
//
//  Created by Мадина Валиева on 31.03.2024.
//

import Foundation

class NewsManager {
    private var cachedNews: [String: [NewsItem]] = [:]
    func getNews(q: String, count: Int, completion:@escaping ([NewsItem]) -> ()) {
        let normalizedQuery = q.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                
                // Check if news items are cached
                if let cachedItems = cachedNews[normalizedQuery] {
                    // If cached, return the cached items
                    completion(cachedItems)
                    return
                }
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "newsapi.org"
        urlComponents.path = "/v2/everything"
        
        urlComponents.queryItems = [
        URLQueryItem(name: "q", value: q),
        URLQueryItem(name: "pageSize", value: "\(count)"),
        URLQueryItem(name: "apiKey", value: "c1417a8991234f7592f514ecebbc16fa"),
        URLQueryItem(name: "language", value: "ru")]
        
//       print(urlComponents.url)
        //2 request
        guard let url = urlComponents.url else { return }
        print(url)
        let req = URLRequest(url: url)
        
        //3 send request
        
        URLSession.shared.dataTask(with: req) { data, _, err in
            guard
                err == nil,
                let resData = data
            else {
                print(err!.localizedDescription)
                return
            }
            
            do {
               let result = try JSONDecoder().decode(MainNews.self, from: resData)
                completion(result.articles)
                print(result.articles)
            } catch let error {
                print(error.localizedDescription)
            }
            
        }.resume()
    }
}
