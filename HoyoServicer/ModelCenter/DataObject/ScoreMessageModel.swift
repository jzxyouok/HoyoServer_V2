//
//  ScoreMessageModel.swift
//  HoyoServicer
//
//  Created by SH15BG0110 on 16/5/20.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import Foundation
import CoreData


class ScoreMessageModel: DataObject {
    
    // Insert code here to add functionality to your managed object subclass
    class func GetSourceArr(newModel: String,entityName: String)  ->  [ScoreMessageModel]{
        var scoreArr: [ScoreMessageModel]  = []
        
        let entity = NSEntityDescription.entityForName("ScoreMessageModel", inManagedObjectContext: appDelegate.managedObjectContext)
        
        let request = NSFetchRequest()
        request.entity = entity
        
        let arr:[ScoreMessageModel] = try! appDelegate.managedObjectContext.executeFetchRequest(request) as! [ScoreMessageModel]
        for item in arr {
            print(item.sendUserid)
            if item.sendUserid == newModel{
                scoreArr.append(item)
            }
        }
        
        return scoreArr
    }
    
    class func deleteSource(newModel: String,entityName: String) {
        
        let entity = NSEntityDescription.entityForName("ScoreMessageModel", inManagedObjectContext: appDelegate.managedObjectContext)
        
        let request = NSFetchRequest()
        request.entity = entity
        
        let arr:[ScoreMessageModel] = try! appDelegate.managedObjectContext.executeFetchRequest(request) as! [ScoreMessageModel]
        
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
