//
//  ShopListApp.swift
//  ShopList
//
//  Created by snoopy on 18/07/2021.
//

import SwiftUI

@main
struct ShopListApp: App {
    
    let persistentContainer = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            homeView()
                .environment(\.managedObjectContext, persistentContainer.container.viewContext)
        }
    }
}
