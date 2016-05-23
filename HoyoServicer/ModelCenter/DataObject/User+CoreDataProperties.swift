//
//  User+CoreDataProperties.swift
//  HoyoServicer
//
//  Created by 赵兵 on 16/4/18.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var bannerimgs: String?
    @NSManaged var bdimgs: String?
    @NSManaged var city: String?
    @NSManaged var country: String?
    @NSManaged var groupdetails: NSData?
    @NSManaged var headimageurl: NSData?
    @NSManaged var language: String?
    @NSManaged var mobile: String?
    @NSManaged var name: String?
    @NSManaged var openid: String?
    @NSManaged var orderabout: NSData?
    @NSManaged var province: String?
    @NSManaged var realname: NSData?
    @NSManaged var scope: String?
    @NSManaged var score: String?
    @NSManaged var sex: String?
    @NSManaged var id: String?//userid
    @NSManaged var usertoken: String?

}
