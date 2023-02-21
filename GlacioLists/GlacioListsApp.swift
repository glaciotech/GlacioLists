//
//  GlacioListsApp.swift
//  GlacioLists
//
//  Created by Peter Liddle on 2/20/23.
//

import SwiftUI
import RealmSwift

@main
struct GlacioListsApp: SwiftUI.App {
    
    let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "glaciolistdata", deleteRealmIfMigrationNeeded: true))
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.realm, realm)
        }
    }
}
