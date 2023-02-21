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
        
        let seedNode = UserDefaults.standard.string(forKey: "seedNode")
        let chaindir = UserDefaults.standard.string(forKey: "chaindir")
        let port = UInt16(UserDefaults.standard.integer(forKey: "port"))
        
        do {
            
            let seedNodes = seedNode != nil ? [seedNode!] : []
            
            nodeManager = try NodeManager(chaindir: chaindir ?? "main", port: port, seedNodes: seedNodes)
            
            try nodeManager.node.addChain(chainId: GlacioListConstants.chainId)
            
            glacioObserver = GlacioNodeObserver(node: nodeManager.node, realm: realm)
            try glacioObserver.createNodeObservers()
            
            guard let dApp = nodeManager.node.app(appType: RealmChangeDApp.self) else {
                fatalError("Can't continue as cannot get an instance of Realm DApp")
            }
            realmObserver = RealmChangeObserver(realm: realm, realmDApp: dApp)
            realmObserver.createAndStartObservers()
            
            nodeManager.seedNodesRegisteredCallback = { [self] in
                
                do {
                    try nodeManager.node.sync(full: true, chainId: GlacioListConstants.chainId)
                }
                catch {
                    print(error)
                }
            }
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
