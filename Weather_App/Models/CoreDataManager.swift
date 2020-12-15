//
//  CoreDataManager.swift
//  Weather_App
//
//  Created by Roman Kantor on 2020-11-26.
//  Copyright © 2020 Roman Kantor. All rights reserved.
//

import Foundation
import CoreData

// string extension to return the first character of the city
extension NSString{
  @objc func firstChar() -> String{ // @objc is needed to avoid crash
    if self.length == 0 {
      return ""
    }
    return self.substring(to: 1)
  }
}

class CoreDataManager {
    
    static var shared = CoreDataManager()
    
    // fetch result controller to update the table 
    lazy var frc : NSFetchedResultsController<FavLocation> = {
        let fetch : NSFetchRequest<FavLocation> = FavLocation.fetchRequest()
    
        fetch.sortDescriptors = [NSSortDescriptor(key: "city", ascending: true)]
        
        let result = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: CoreDataManager.shared.persistentContainer.viewContext, sectionNameKeyPath: "city.firstChar", cacheName: nil)
        
        return result
    }()
    
    // fetch result controller for the Search
    lazy var frcSearch : NSFetchedResultsController<FavLocation> = {
        let fetch : NSFetchRequest<FavLocation> = FavLocation.fetchRequest()
    
        fetch.sortDescriptors = [NSSortDescriptor(key: "city", ascending: true)]
          
        let result = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: CoreDataManager.shared.persistentContainer.viewContext, sectionNameKeyPath: "city.firstChar", cacheName: nil)
          
        return result
      }()
    
    // add new location to favorites and save to Core Data
    func addLocation(location: Location, allLocations: [FavLocation]) {
        var recordExists = false;
        
        //check if selected location already saved
        for loc in allLocations {
            if loc.city == location.city && loc.country == location.country {
                recordExists = true;
            }
        }
        
        if !recordExists {
           let newFavLocation = FavLocation(context: persistentContainer.viewContext)
           newFavLocation.city = location.city
           newFavLocation.country = location.country
           
           saveContext()
        }
    }
    
    // fetch current favorite locations
//    func fetchFavLocations()->[FavLocation]  {
//
//        let fetch : NSFetchRequest = FavLocation.fetchRequest()
//
//        fetch.sortDescriptors = [NSSortDescriptor.init(key: "city", ascending: true)]
//
//        var results = [FavLocation]()
//        do {
//            results = try persistentContainer.viewContext.fetch(fetch) as [FavLocation]
//        }catch {
//
//        }
//        return results
//
//    }
    
    // delete location from favorite locations
    func deleteLocation(favLocationToDelete: FavLocation)  {
        persistentContainer.viewContext.delete(favLocationToDelete)
        saveContext()
    }
    
    // search method
    func searchInFavorite(searchText : String) -> NSFetchedResultsController<FavLocation> {
        let fetch : NSFetchRequest<FavLocation> = FavLocation.fetchRequest()
    
        let customPredicate = NSPredicate(format: "city BEGINSWITH [c] %@", searchText)
        fetch.predicate = customPredicate
        fetch.sortDescriptors = [NSSortDescriptor(key: "city", ascending: false)]
        
        let result = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: CoreDataManager.shared.persistentContainer.viewContext, sectionNameKeyPath: "city.firstChar", cacheName: nil)
        
        return result
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
         /*
          The persistent container for the application. This implementation
          creates and returns a container, having loaded the store for the
          application to it. This property is optional since there are legitimate
          error conditions that could cause the creation of the store to fail.
         */
         let container = NSPersistentContainer(name: "Weather_App")
         container.loadPersistentStores(completionHandler: { (storeDescription, error) in
             if let error = error as NSError? {
                 // Replace this implementation with code to handle the error appropriately.
                 // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                  
                 /*
                  Typical reasons for an error here include:
                  * The parent directory does not exist, cannot be created, or disallows writing.
                  * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                  * The device is out of space.
                  * The store could not be migrated to the current model version.
                  Check the error message to determine what the actual problem was.
                  */
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
                 // Replace this implementation with code to handle the error appropriately.
                 // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 let nserror = error as NSError
                 fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
             }
         }
    }
    
}
