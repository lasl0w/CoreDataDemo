//
//  CoreDataDemoApp.swift
//  CoreDataDemo
//
//  Created by tom montgomery on 6/10/23.
//

import SwiftUI

@main
struct CoreDataDemoApp: App {
    // base reference to coreData DB.  give me the singleton!
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            // they add it as an EO to make it easy to have it everywhere we need
        }
    }
}
