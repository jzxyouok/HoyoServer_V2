//
//  DataObject.swift
//  HoyoServicer
//
//  Created by 赵兵 on 16/3/28.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//

import Foundation
import CoreData


class DataObject: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    private class func cast<T>(object: NSManagedObject, type: T.Type) -> T {
        return object as! T
    }
    
    class func cachedObjectWithID(ID: NSString) -> Self {
        print(entityName)
        return cast(DataManager.defaultManager!.autoGenerate(entityName, ID: ID), type: self)
    }
    
    class func allCachedObjects() -> [DataObject] /* [Self] in not supported. */ {
        return DataManager.defaultManager!.fetchAll(entityName, error: nil)
        
    }
    
    class func deleteAllCachedObjects() {
        DataManager.defaultManager!.deleteAllObjectsWithEntityName(entityName)
    }
    
//    class func temporaryObject() -> Self {
//        return cast(DataManager.temporaryManager!.create(entityName), type: self)
//    }
    
    class var entityName: String {
        
        let s:String = NSStringFromClass(self)
        return s.componentsSeparatedByString(".").last ?? s
    }
}
