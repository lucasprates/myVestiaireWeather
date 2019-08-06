//
//  CoreDataController.swift
//  MyVestiaireWeather
//
//  Created by Lucas on 04/08/2019.
//  Copyright © 2019 LucasPrates. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: NSObject {
    
    var managedContext: NSManagedObjectContext?
    
    // MARK: - Properties
    private static var sharedCoreDataController: CoreDataController = {
        let coreDataController = CoreDataController()
        return coreDataController
    }()
    
    class func shared() -> CoreDataController {
        return sharedCoreDataController
    }
    
    // MARK: - Inits
    private override init() {
        super.init()
        let _ = self.getContextDB()
    }
    
    func getContextDB() -> NSManagedObjectContext? {
        if(self.managedContext == nil){
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            self.managedContext = appDelegate?.persistentContainer.viewContext
        }
        
        return self.managedContext
    }
    
    func saveCoreDataDB() {
        do {
            //save Core DB Context
            try self.getContextDB()?.save()
        } catch {
            let message: String = "Error: Failure to save context - at CoreDataController"
            print(message)
        }
    }
    
    func getObjects(ofEntity entityName: String, withPredicate predicate: String?) -> Any? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            if let predicateFilled = predicate {
                fetchRequest.predicate = NSPredicate(format: predicateFilled)
            }
            let fetchedResults = try self.getContextDB()?.fetch(fetchRequest)
            return fetchedResults
        } catch {
            fatalError("Failed to fetch entity named \(entityName) - Error: \(error)")
        }
    }
    
    func removeAllStoredData(ofEntity entityName: String) {
        //remove all content of especific entity in Core Data DB
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try self.getContextDB()?.execute(deleteRequest)
        } catch let error as NSError {
            let message: String = "Error: Not bale to remove all entities of name \(entityName) - at CoreDataController"
            print("Error: \(error) - \(message)")
        }
        self.saveCoreDataDB()
    }
    
    func removeAllData() {
        //remove all Assignments in Core Data DB
        if let entityNames: [String?] = managedContext?.persistentStoreCoordinator?.managedObjectModel.entities.map({ (entity) -> String? in return entity.name }){
            for nameUnit in entityNames {
                if let nameUnitFilled: String = nameUnit {
                    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: nameUnitFilled)
                    let request = NSBatchDeleteRequest(fetchRequest: fetch)
                    do {
                        _ = try self.getContextDB()?.execute(request)
                    } catch let error as NSError {
                        let message: String = "Error: Failed to clear all existing entities from Core Data DB - at CoreDataController"
                        print("Error: \(error) - \(message)")
                    }
                }
            }
            self.saveCoreDataDB()
        }
    }
}
