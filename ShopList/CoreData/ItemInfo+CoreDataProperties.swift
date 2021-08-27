//
//  ItemInfo+CoreDataProperties.swift
//  ShopList
//
//  Created by snoopy on 19/07/2021.
//
//

import Foundation
import CoreData


extension ItemInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemInfo> {
        return NSFetchRequest<ItemInfo>(entityName: "ItemInfo")
    }

    @NSManaged public var itemImage: Data?
    @NSManaged public var itemName: String?
    @NSManaged public var itemQuantity: String
    @NSManaged public var itemStatus: Bool
    @NSManaged public var itemPrice : String
    @NSManaged public var list: ListInfo?
    
    public var wrappeditemName : String{
        itemName ?? "Unknown item"
    }
    

}

extension ItemInfo : Identifiable {

}
