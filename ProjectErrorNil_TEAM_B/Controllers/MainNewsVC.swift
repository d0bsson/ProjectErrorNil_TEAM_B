//
//  MainNewsVC.swift
//  ProjectErrorNil_TEAM_B
//
//  Created by Мадина Валиева on 29.03.2024.
//

import UIKit

class MainNewsVC: UIViewController, UICollectionViewDelegate {
    private let manager = VKManager()
    func getFavoritedNewsItems() -> [NewsItem] {
        
        guard let news = news else { return [] }
        return news.articles.filter { $0.isFavorite ?? false }
    }
    var delegate: SceneDelegate?
    
    private let network = NewsManager()
    
    private(set) var news: MainNews? = .init(totalResults: 0, articles: []) {
        willSet {
            if !Thread.isMainThread {
                fatalError("must be in main thread")
            }
        }
    }
    
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
    
    lazy var collection = viewBuilder.createCollection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUserInfo()
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 180),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)])
        
        view.addSubview(collection)
        
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collection.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
        ])
        
        setupSearchController()
            }
    
    private func setUserInfo() {
        manager.getInfo { info in
            DispatchQueue.main.async {
                let name = "\(info.response.firstName) \(info.response.lastName)"
                self.navigationItem.title = name
            }
        }
    }
  
    func updateNews(_ news: MainNews) {
        DispatchQueue.main.async {
            self.news = news
            self.collection.reloadData()
        }
    }
    
    func addIdTo(newsItems: inout [NewsItem]) {
        for index in newsItems.indices {
            newsItems[index].newsId = UUID()
            newsItems[index].isFavorite = false
        }
    }
    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.barTintColor = UIColor(red: 70/255,green: 70/255,blue: 71/255, alpha:0.9)
        searchController.searchBar.tintColor = UIColor.lightGray
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.searchBar.delegate = self
        searchController.searchBar.barStyle = UIBarStyle.black
        navigationItem.searchController = searchController
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
            textField.textColor = .black
        }
    }
    
    func formattedDate(from dateString: String?) -> String? {
        guard let dateString = dateString else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "dd MMMM yyyy"
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
}


extension MainNewsVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news?.articles.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainNewsCell.reuseId, for: indexPath) as! MainNewsCell
        
        let newsItem = NewsItem(newsId: news?.articles[indexPath.row].newsId,
                                title: news?.articles[indexPath.row].title,
                                description: news?.articles[indexPath.row].description,
                                url: news?.articles[indexPath.row].url,
                                urlToImage: news?.articles[indexPath.row].urlToImage,
                                publishedAt: news?.articles[indexPath.row].publishedAt,
                                content: news?.articles[indexPath.row].content,
                                isFavorite: news?.articles[indexPath.row].isFavorite)
        if let isFavorite = news?.articles[indexPath.row].isFavorite {
            cell.isStarFilled = isFavorite
        }
        
        cell.setItems(item: newsItem)
        cell.delegate = self
        return cell
    }
}

extension MainNewsVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        self.network.getNews(q: searchText, count: 15) { [weak self] items in
            var newsItems = items
            self?.addIdTo(newsItems: &newsItems)
            self?.updateNews(.init(totalResults: items.count, articles: newsItems))
            DispatchQueue.main.async {
                self?.collection.reloadData()
            }
        }
    }
}

extension MainNewsVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}
extension MainNewsVC: NewsCellDelegate {
    func didTapButton(in cell: MainNewsCell) {
        
        cell.isStarFilled.toggle()
        
        let indexPath = collection.indexPath(for: cell)
        print(indexPath?.row)
        
        let selectedNewsItem = news?.articles[indexPath?.row ?? 0]
        
        for index in news!.articles.indices {
            
            if news?.articles[index].newsId == selectedNewsItem?.newsId {
                
                guard var news1 = news else { return }
                
                if (selectedNewsItem?.isFavorite)! {
                    CoreDataManager.shared.deleteNewsItem(selectedNewsItem!) { fail in
                        if fail{
                            print("удаление")
                        }
                    }
                } else {
                    
                    if let selectedNewsItem = selectedNewsItem {
                        CoreDataManager.shared.saveNewsItem(selectedNewsItem) { success in
                            if success {
                                print("Cохранено")
                                
                                let favoritedNewsItems = self.getFavoritedNewsItems()
                                
                                let storageVC = StorageVC()
                                storageVC.newsItem = favoritedNewsItems
                            } else {
                                print("Не сохранено")
                            }
                        }
                    }
                    
                    news1.articles[index].isFavorite?.toggle()
                    updateNews(news1)
                    
                }
            }
        }
    }
}


