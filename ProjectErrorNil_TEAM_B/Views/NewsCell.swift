//
//  NewsCell.swift
//  ProjectErrorNil_TEAM_B
//
//  Created by Мадина Валиева on 31.03.2024.
//

import UIKit

class NewsCell: UICollectionViewCell {
    
    static let reuseId = "NewsCell"
   
    private var fullUrlString: String?
    
    lazy var cellView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.addSubview(imageView)
        $0.addSubview(urlLabel)
        $0.addSubview(descriptionLabel)
        $0.addSubview(titleLabel)
        $0.addSubview(dateLabel)
        
        return $0
    }(UIView())
    
    lazy var imageView: UIImageView = {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 240).isActive = true
        return $0
        
    }(UIImageView())
    
    
    private lazy var urlLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleUrlLabelTap))
        $0.isUserInteractionEnabled = true
        $0.addGestureRecognizer(tapGesture)
        
        return $0
    }(UILabel())
    @objc private func handleUrlLabelTap() {
        guard let urlString = fullUrlString, let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    private lazy var dateLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = UIColor(red: 0.65, green: 0.65, blue: 0.65, alpha: 1)
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UILabel())
    
    private lazy var titleLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UILabel())
    
    
    private lazy var descriptionLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.layer.frame = bounds
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UILabel())
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cellView)
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            cellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            cellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            cellView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
            
            imageView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 0),
            imageView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: 0),
            
            urlLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            urlLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10),
            urlLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant:-10),
            
            dateLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant:-10),
            
            titleLabel.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant:-10),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant:-10),
            descriptionLabel.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -30)
            
        ])
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
    
    
    func setItems(item: NewsItem) {
        guard let imageUrlString = item.urlToImage,
                let imageUrl = URL(string: imageUrlString) else {
              return
          }

          if let cachedImage = ImageCache.shared.image(forKey: imageUrlString) {
              imageView.image = cachedImage
          } else {
              DispatchQueue.global().async {
                  if let data = try? Data(contentsOf: imageUrl),
                     let image = UIImage(data: data) {
                      ImageCache.shared.setImage(image, forKey: imageUrlString)
                      DispatchQueue.main.async {
                          self.imageView.image = image
                      }
                  }
              }
          }
        
        fullUrlString = item.url
        urlLabel.text = item.url?.toHost
        dateLabel.text = formattedDate(from: item.publishedAt)
        descriptionLabel.text = item.description
        titleLabel.text = item.title
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension String {
    var toHost: String? {
        guard let encodeUrl = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let components = URLComponents(string: encodeUrl) else { return nil }
        return "\(components.scheme ?? "")://\(components.host ?? "")"
    }
}
