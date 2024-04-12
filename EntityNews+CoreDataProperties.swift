//
//  EntityNews+CoreDataProperties.swift
//  ProjectErrorNil_TEAM_B
//
//  Created by Мадина Валиева on 09.04.2024.
//
//

import Foundation
import CoreData


extension EntityNews {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EntityNews> {
        return NSFetchRequest<EntityNews>(entityName: "EntityNews")
    }

    @NSManaged public var descriptionNews: String?
    @NSManaged public var title: String?
    @NSManaged public var urlWeb: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var date: String?

}

extension EntityNews : Identifiable {


}

