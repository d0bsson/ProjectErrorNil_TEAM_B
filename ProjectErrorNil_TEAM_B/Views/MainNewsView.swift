//
//  MainNewsView.swift
//  ProjectErrorNil_TEAM_B
//
//  Created by Мадина Валиева on 31.03.2024.
//

import Foundation
import UIKit

class MainNewsView {
    
    var view: UIView
    var dataSource: UICollectionViewDataSource
    var delegate: UICollectionViewDelegate
    init(view: UIView, dataSource: UICollectionViewDataSource, delegate: UICollectionViewDelegate) {
        self.view = view
        self.dataSource = dataSource
        self.delegate = delegate
    }
    
    func createCollection() -> UICollectionView {
        let collectionView: UICollectionView = {
            
            let layout = $0.collectionViewLayout as! UICollectionViewFlowLayout
            layout.scrollDirection = .vertical
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            $0.dataSource = dataSource
            $0.delegate = delegate
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.register(MainNewsCell.self, forCellWithReuseIdentifier: MainNewsCell.reuseId)
            $0.register(StorageCell.self, forCellWithReuseIdentifier: StorageCell.reuseId)
            return $0
        }(UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()))
        
        return collectionView
    }
}


