//
//  NewsVKCell.swift
//  ProjectErrorNil_TEAM_B
//
//  Created by d0bsson on 17.04.2024.
//

import UIKit

class NewsVKCell: UICollectionViewCell {
    static let reuseId = "id"
    
    let dateFormatter: DateFormatter = {
            let dt = DateFormatter()
            dt.locale = Locale(identifier: "ru_RU")
            dt.dateFormat = "d MMMM YYYY года"
            return dt
        }()
    
    private lazy var cellView: UIView = {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
        $0.backgroundColor = UIColor(_colorLiteralRed: 248/255, green: 248/255, blue: 248/255, alpha: 1)
        $0.addSubview(imageCell)
        $0.addSubview(titleCell)
        $0.addSubview(titleDate)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    lazy var imageCell: UIImageView = {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    lazy var titleCell: UILabel = {
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    lazy var titleDate: UILabel = {
        $0.numberOfLines = 0
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = UIColor(_colorLiteralRed: 166/255, green: 166/255, blue: 166/255, alpha: 1)
        $0.font = .systemFont(ofSize: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    func setupCell(url: String, data: Video, date: Video) {
        setupConstraints()
        setupImage(url: url)
        setupDate(video: date)
        titleCell.text = data.title
    }
    
    private func setupDate(video: Video) {
        let timeIntervalSince1970 = TimeInterval(video.date)
        let date = Date(timeIntervalSince1970: timeIntervalSince1970)
        let dateTitle = dateFormatter.string(from: date)
        self.titleDate.text = dateTitle
        print(video.date)
    }
    
    private func setupImage(url: String) {
        guard let imageURL = URL(string: url) else { return }
        ImageManager.shared.loadImage(url: imageURL) { data in
            self.imageCell.image = UIImage(data: data)
        }
    }
    
    private func setupConstraints() {
        self.addSubview(cellView)
        NSLayoutConstraint.activate([
            
            cellView.topAnchor.constraint(equalTo: self.topAnchor),
            cellView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 8),
            cellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            titleCell.leadingAnchor.constraint(equalTo: imageCell.leadingAnchor, constant: 20),
            titleCell.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -8),
            titleCell.trailingAnchor.constraint(equalTo: imageCell.trailingAnchor, constant: -8),
            
            titleDate.leadingAnchor.constraint(equalTo: imageCell.leadingAnchor, constant: 20),
            titleDate.bottomAnchor.constraint(equalTo: titleCell.topAnchor, constant: -8),
            titleDate.trailingAnchor.constraint(equalTo: imageCell.trailingAnchor, constant: -8),
            
            imageCell.topAnchor.constraint(equalTo: cellView.topAnchor),
            imageCell.leadingAnchor.constraint(equalTo: cellView.leadingAnchor),
            imageCell.trailingAnchor.constraint(equalTo: cellView.trailingAnchor),
            imageCell.bottomAnchor.constraint(equalTo: titleDate.topAnchor, constant: -8)
            
        ])
    }
}
