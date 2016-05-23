//
//  ProductInfo+CoreDataProperties.swift
//  HoyoServicer
//
//  Created by 杨龙洲 on 23/5/16.
//  Copyright © 2016年 com.ozner.net. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ProductInfo {

    @NSManaged var company: String?
    @NSManaged var id: String?
    @NSManaged var image: String?
    @NSManaged var name: String?
    @NSManaged var price: String?
    @NSManaged var productCode: String?
    @NSManaged var productType: String?

}
