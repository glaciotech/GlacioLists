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

    let debugModel: DebugModel
    let nodeInfoModel: NodeInfoModel

    init() {
        
        let seedNode = UserDefaults.standard.string(forKey: "seedNode")
        let chainDirPath = UserDefaults.standard.string(forKey: "chaindir") ?? "main"
        let port = UInt16(UserDefaults.standard.integer(forKey: "port"))

        let discoveryServiceAddress = UserDefaults.standard.string(forKey: "discoveryAddress")
        let disableDiscoverability = UserDefaults.standard.bool(forKey: "disableDiscoverability")

        do {
            let seedNodes = seedNode != nil ? [seedNode!] : []

            let discAddr = disableDiscoverability ? nil : discoveryServiceAddress // If discovery service disabled set to nil to disable it on NodeManager

            self.nodeManager = try NodeManager(developerId: developerId, chaindir: chainDirPath, port: port, seedNodes: seedNodes, discoverabilityServiceAddress: discAddr)
            self.realm = try Realm(configuration: Realm.Configuration(inMemoryIdentifier: "glaciolistdata-\(chainDirPath)", deleteRealmIfMigrationNeeded: true)) // We use ! here as if realm can't initialize our app won't work

            self.glacioCoordinator = try GlacioRealmCoordinator(realm: realm, nodeManager: nodeManager, objectsToMonitor: [ListItem.self])

            self.nodeInfoModel = NodeInfoModel(node: nodeManager.node)
            self.debugModel = DebugModel(node: nodeManager.node)
        }
        catch {
            fatalError("Fatal error starting app: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(chainId: glacioCoordinator.chainId)
                .environment(\.realm, realm)
                .environmentObject(nodeInfoModel)
                .environmentObject(debugModel)
        }
    }
}
