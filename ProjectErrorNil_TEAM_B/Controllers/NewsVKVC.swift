//
//  NewsVKVC.swift
//  ProjectErrorNil_TEAM_B
//
//  Created by Мадина Валиева on 29.03.2024.
//

import UIKit

class NewsVKVC: UIViewController {
    
    private let manager = VKManager()
    private var videos: [Video] = []
    
    lazy var collectionView: UICollectionView = {
        let screenSize = UIScreen.main.bounds
        let width = screenSize.width
        let height = screenSize.height
        let layout = $0.collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.bounds.width, height: view.bounds.width-20)
        
        $0.dataSource = self
        $0.backgroundColor = .clear
        $0.register(NewsVKCell.self, forCellWithReuseIdentifier: NewsVKCell.reuseId)
        return $0
    }(UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserInfo()
        view.backgroundColor = .white
        getVideo()
        view.addSubview(collectionView)
    }
    
    private func setUserInfo() {
        manager.getInfo { info in
            DispatchQueue.main.async {
                let name = "\(info.response.firstName) \(info.response.lastName)"
                self.navigationItem.title = name
            }
        }
    }
    
    private func getVideo() {
        manager.getVideo { video in
            DispatchQueue.main.async {
                self.videos = video
                self.collectionView.reloadData()
            }
        }
    }
}

extension NewsVKVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsVKCell.reuseId, for: indexPath) as! NewsVKCell
        
        if videos.count != 0 {
            let data = videos[indexPath.item]
            if let url = videos[indexPath.item].image.last?.url {
                cell.setupCell(url: url, data: data, date: data)
            }
        }
        return cell
    }
}


