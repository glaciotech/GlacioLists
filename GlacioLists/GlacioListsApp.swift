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
    
    let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "glaciolistdata", deleteRealmIfMigrationNeeded: true))
    
    let nodeManager: NodeManager
    
    let realmObserver: RealmChangeObserver
    
    let glacioObserver: GlacioNodeObserver
    
    init() {
        
        do {
            nodeManager = try NodeManager(seedNodes: [])
            try nodeManager.node.addChain(chainId: GlacioListConstants.chainId)
            
            glacioObserver = GlacioNodeObserver(node: nodeManager.node, realm: realm)
            
            guard let dApp = nodeManager.node.app(appType: RealmChangeDApp.self) else {
                fatalError("Can't continue as cannot get an instance of Realm DApp")
            }
            realmObserver = RealmChangeObserver(realm: realm, realmDApp: dApp)
            realmObserver.createAndStartObservers()
        }
        catch {
            fatalError("Fatal error stating app: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.realm, realm)
        }
    }
}
