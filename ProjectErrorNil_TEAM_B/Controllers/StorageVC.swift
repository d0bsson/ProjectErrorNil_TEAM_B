//
//  StorageVC.swift
//  ProjectErrorNil_TEAM_B
//
//  Created by Мадина Валиева on 29.03.2024.
//

import UIKit

class StorageVC: UIViewController, UICollectionViewDelegate {
   
    var newsItem: [NewsItem] = []
    
    let newsEntity = CoreDataManager.shared.fetchAllNewsItems()?.last
    var entity: [EntityNews] = []
    var storageMnager = StorageManager()

    private lazy var viewBuilder: MainNewsView = {
        return MainNewsView(view: self.view, dataSource: self, delegate: self)
    }()
    lazy var collection = UICollectionView()
    private lazy var titleLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.text = "Хранилище"
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 180),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)])
        
        collection = viewBuilder.createCollection()

        view.addSubview(collection)
        
        NSLayoutConstraint.activate([
            collection.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collection.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100)
            
        ])
        
        setupSearchController()
       
    }
        
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            updateStoredNews()
        }
        
        func updateStoredNews() {
            if let entityNews = CoreDataManager.shared.fetchAllNewsItems() {
                newsItem = entityNews.map { entity in
                    return NewsItem(title: entity.title ?? "",
                                    description: entity.descriptionNews ?? "",
                                    url: entity.urlWeb ?? "",
                                    urlToImage: entity.urlToImage ?? "",
                                    publishedAt: entity.date ?? "",
                                    content: "",
                                    isFavorite: false)
                }
                collection.reloadData()
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
    
extension StorageVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        newsItem.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StorageCell.reuseId, for: indexPath) as! StorageCell
        
        let news = newsItem[indexPath.row]
        cell.setItems(item: news)
  
        return cell
    }
}
extension StorageVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
      
        
    }
}
extension StorageVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

        

