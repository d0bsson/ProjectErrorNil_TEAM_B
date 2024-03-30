//
//  TabControllers.swift
//  ProjectErrorNil_TEAM_B
//
//  Created by Мадина Валиева on 29.03.2024.
//

import UIKit

class TabControllers: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabs()

    }
    
    private func setupTabs() {
        let mainNewsVC = self.createNav(with: "Новости", image: UIImage(systemName: "star"), vc: MainNewsVC())
        let newsVK = self.createNav(with: "Error Nil VK", image: resizeImage(image: UIImage(named: "vk"), targetSize: CGSize(width: 30, height: 30)), vc: NewsVKVC())
        let storageVC = self.createNav(with: "Хранилище", image: UIImage(systemName: "star.fill"), vc: StorageVC())

        self.setViewControllers([mainNewsVC,newsVK, storageVC], animated: true)
        
    }
    private func resizeImage(image: UIImage?, targetSize: CGSize) -> UIImage? {
        guard let image = image else {
            return nil
        }

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    private func createNav (with title: String, image: UIImage?, vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        
        return nav
    }

}
