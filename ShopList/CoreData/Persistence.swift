//
//  Persistence.swift
//  ShopList
//
//  Created by snoopy on 18/07/2021.
//

import CoreData

struct PersistenceController{
    static let shared = PersistenceController()
    
    let container : NSPersistentCloudKitContainer
    
    init(){
        container = NSPersistentCloudKitContainer(name : "Item")
        
        container.loadPersistentStores{(storeDescription , error) in
            if let error = error as NSError? {
                fatalError("Unresolved error : \(error)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
    }
}
