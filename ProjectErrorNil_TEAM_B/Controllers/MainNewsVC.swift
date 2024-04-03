//
//  MainNewsVC.swift
//  ProjectErrorNil_TEAM_B
//
//  Created by Мадина Валиева on 29.03.2024.
//

import UIKit

class MainNewsVC: UIViewController, UICollectionViewDelegate {
    
    private let network = NewsManager()
    
    var newsItem: [NewsItem] = []
    lazy var collection = UICollectionView()
    
    var news: MainNews?
    
    
    private lazy var viewBuilder: MainNewsView = {
        return MainNewsView(view: self.view, dataSource: self, delegate: self)
    }()
    
    private lazy var titleLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.text = "Новости"
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 159),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)])
        
        collection = viewBuilder.createCollection()
        
        
        view.addSubview(collection)
        
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collection.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
            
        ])
        
        network.getNews(q: "Trump", count: 10) { [weak self] items in
            print(items.first?.urlToImage ?? "")
            
            self?.news = .init(totalResults: (self?.newsItem.count)!, articles: items)
            
            DispatchQueue.main.async {
                self?.collection.reloadData()
            }
            
        }
        
    }
    
}
extension MainNewsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        news?.articles.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.reuseId, for: indexPath) as! NewsCell
        let newsItem = NewsItem(title: news?.articles[indexPath.row].title,
                                description: news?.articles[indexPath.row].description,
                                url: news?.articles[indexPath.row].url,
                                urlToImage: news?.articles[indexPath.row].urlToImage,
                                publishedAt: news?.articles[indexPath.row].publishedAt,
                                content: news?.articles[indexPath.row].content)
        
        cell.setItems(item: newsItem)
        return cell
    }
    
    
}
