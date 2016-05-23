//
//  DataManager.swift
//  WeCenterMobile
//
//  Created by Darren Liu on 15/10/7.
//  Copyright (c) 2015年 BetaTech. All rights reserved.
//

import CoreData
import Foundation

class DataManager: NSObject {
    
    private static var _defaultManager: DataManager! = nil
    
    static var defaultManager: DataManager! {
        get {
            if _defaultManager == nil {
                _defaultManager = DataManager()
            }
            return _defaultManager
        }
        set {
            _defaultManager = newValue
        }
    }

    func create(entityName: String) -> DataObject {
        let entity = appDelegate.managedObjectModel.entitiesByName[entityName]!
        return DataObject(entity: entity, insertIntoManagedObjectContext: appDelegate.managedObjectContext)
    }
    func fetch(entityName: String, ID: NSString, error: NSErrorPointer) -> DataObject? {
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = NSPredicate(format: "id = %@", ID)
        request.fetchLimit = 1
        var results:[AnyObject]?   
        do {
            results = try appDelegate.managedObjectContext.executeFetchRequest(request)
        } catch {
            print("无")
        }
        
        if results != nil && results!.count != 0 {
            return results![0] as? DataObject
        } else {
            if error != nil && error.memory == nil {
                error.memory = NSError(domain: "", code: 0, userInfo: nil) // Needs specification
            }
            return nil
        }
    }
    func fetchAll(entityName: String, error: NSErrorPointer) -> [DataObject] {
        let request = NSFetchRequest(entityName: entityName)
        let results = try? appDelegate.managedObjectContext.executeFetchRequest(request)
        if results != nil {
            return results as! [DataObject]
        } else {
            if error != nil && error.memory == nil {
                error.memory = NSError(domain: "", code: 0, userInfo: nil) // Needs specification
            }
            return []
        }
    }
    func autoGenerate(entityName: String, ID: NSString) -> DataObject {
        var object = fetch(entityName, ID: ID, error: nil)
        if object == nil {
            object = create(entityName)
            object!.setValue(ID, forKey: "id")
        }
        return object!
    }
    func deleteAllObjectsWithEntityName(entityName: String) {
        var error: NSError?
        let request = NSFetchRequest(entityName: entityName)
        request.predicate = NSPredicate(value: true)
        let results = try? appDelegate.managedObjectContext.executeFetchRequest(request)
        if results != nil {
            for r in results! {
                appDelegate.managedObjectContext.deleteObject(r as! NSManagedObject)
            }
        } else {
            if error != nil {
                error = NSError(domain: "清空表\(entityName)错误", code: 0, userInfo: nil)
                print(error)
            }
        }
        
    }
    func saveChanges() {
        appDelegate.saveContext()
//        if managedObjectContext?.hasChanges ?? false {
//            do
//            {
//                try! managedObjectContext?.save()
//            }
//        }
    }
//    var managedObjectModel: NSManagedObjectModel!
//    var managedObjectContext: NSManagedObjectContext?
}
