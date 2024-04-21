//
//  CoreDataManager.swift
//  ProjectErrorNil_TEAM_B
//
//  Created by Мадина Валиева on 08.04.2024.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static var shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ProjectErrorNil_TEAM_B")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchAllNewsItems() -> [EntityNews]? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<EntityNews> = EntityNews.fetchRequest()
        
        do {
            let newsEntities = try context.fetch(fetchRequest)
            return newsEntities
        } catch {
            print("Ошибка при извлечении новостей: \(error.localizedDescription)")
            return nil
        }
        saveContext()
    }
    
    
    func saveNewsItem(_ newsItem: NewsItem, completion: @escaping (Bool) -> ()) {
        let context = persistentContainer.viewContext
        let newItemEntity = EntityNews(context: context)
        newItemEntity.title = newsItem.title
        newItemEntity.descriptionNews = newsItem.description
        newItemEntity.urlWeb = newsItem.url
        newItemEntity.date = newsItem.publishedAt
        
        if let imageURLString = newsItem.urlToImage {
            let imageName = imageURLString
            
            URLSession.shared.dataTask(with: URL(string: imageURLString)!) { data, response, error in
                if let error = error {
                    print("Ошибка загрузки изображения: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                guard let imageData = data else {
                    print("Неверные данные изображения")
                    completion(false)
                    return
                }
                DispatchQueue.main.async {
                    let storageManager = StorageManager()
                    storageManager.saveImage(imageName: imageName, imageData: imageData)
                    newItemEntity.urlToImage = imageName
                    self.saveContext()
                    completion(true)
                }
            }.resume()
        } else {
            DispatchQueue.main.async {
                self.saveContext()
                completion(true)
            }
        }
    }
    func deleteNewsItem(_ newsItem: NewsItem, completion: @escaping (Bool) -> ()) {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<EntityNews> = EntityNews.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", newsItem.title!)
        
        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
                try context.save()
                completion(true)
            } else {
                print("Новость с заголовком '\(newsItem.title ?? "") не найдена")
                completion(false)
            }
        } catch {
            print("Ошибка при удалении новости: \(error)")
            completion(false)
        }
    }

}
