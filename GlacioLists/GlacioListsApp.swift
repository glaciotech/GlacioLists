//
//  GlacioListsApp.swift
//  GlacioLists
//
//  Created by Peter Liddle on 2/20/23.
//

import SwiftUI
import RealmSwift
import GlacioSwift
import GlacioCore

@main
struct GlacioListsApp: SwiftUI.App {
    
    let realm: Realm
    let nodeManager: NodeManager
    let glacioCoordinator: GlacioRealmCoordinator
    
    #error("Add developerId here. Can be obtained from Glacio portal - DELETE THIS LINE BEFORE RUNNING")
    let developerId = ""
    
    init() {
        
        do {
            self.nodeManager = try NodeManager(developerId: developerId)
            self.realm = try Realm(configuration: Realm.Configuration(inMemoryIdentifier: "glaciolistdata", deleteRealmIfMigrationNeeded: true)) // We use ! here as if realm can't initialize our app won't work

            self.glacioCoordinator = try GlacioRealmCoordinator(realm: realm, nodeManager: nodeManager, objectsToMonitor: [ListItem.self])
        }
        catch {
            fatalError("Fatal error starting app: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.realm, realm)
        }
    }
}
