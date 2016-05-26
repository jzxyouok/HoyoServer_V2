//
//  MessageModel.swift
//  HoyoServicer
//
//  Created by SH15BG0110 on 16/5/17.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import Foundation
import CoreData


class MessageModel: DataObject {
    
    // Insert code here to add functionality to your managed object subclass
    class func updateSource(newModel: String,entityName: String) {
        
        let entity = NSEntityDescription.entityForName("MessageModel", inManagedObjectContext: appDelegate.managedObjectContext)
        
        let request = NSFetchRequest()
        request.entity = entity
        
        let arr:[MessageModel] = try! appDelegate.managedObjectContext.executeFetchRequest(request) as! [MessageModel]
        
        for item in arr {
            if item.sendUserid == newModel{
                appDelegate.managedObjectContext.deleteObject(item)
            }
        }
        do{
            try appDelegate.managedObjectContext.save()
        } catch {
            print(error)
        }
        
    }
    
    class func deleteSource(newModel: String,entityName: String) {
        
        let entity = NSEntityDescription.entityForName("MessageModel", inManagedObjectContext: appDelegate.managedObjectContext)
        
        let request = NSFetchRequest()
        request.entity = entity
        
        let arr:[MessageModel] = try! appDelegate.managedObjectContext.executeFetchRequest(request) as! [MessageModel]
        
        for item in arr {
            if item.sendUserid == newModel{
                appDelegate.managedObjectContext.deleteObject(item)
            }
        }
        do{
            try appDelegate.managedObjectContext.save()
        } catch {
            print(error)
        }
        
    }

}
