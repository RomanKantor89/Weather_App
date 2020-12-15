//
//  FavLocation+CoreDataProperties.swift
//  
//
//  Created by Eden Giterman on 2020-12-04.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension FavLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavLocation> {
        return NSFetchRequest<FavLocation>(entityName: "FavLocation")
    }

    @NSManaged public var city: String?
    @NSManaged public var country: String?

}
