//
//  ListInfo+CoreDataProperties.swift
//  ShopList
//
//  Created by snoopy on 19/07/2021.
//
//

import Foundation
import CoreData


extension ListInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListInfo> {
        return NSFetchRequest<ListInfo>(entityName: "ListInfo")
    }

    @NSManaged public var listDate: Date?
    @NSManaged public var listName: String?
    @NSManaged public var item: NSSet?

    public var itemArray : [ItemInfo]{
        let set = item as? Set<ItemInfo> ?? []
        
        return set.sorted{
            $0.wrappeditemName < $1.wrappeditemName
        }
    }
    
}

// MARK: Generated accessors for item
extension ListInfo {

    @objc(addItemObject:)
    @NSManaged public func addToItem(_ value: ItemInfo)

    @objc(removeItemObject:)
    @NSManaged public func removeFromItem(_ value: ItemInfo)

    @objc(addItem:)
    @NSManaged public func addToItem(_ values: NSSet)

    @objc(removeItem:)
    @NSManaged public func removeFromItem(_ values: NSSet)

}

extension ListInfo : Identifiable {

}
