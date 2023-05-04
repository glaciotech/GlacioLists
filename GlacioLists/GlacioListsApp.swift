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

#if LINUXTESTING
#warning("Linux testing is enabled")
#endif

#if ENABLE_NIO_ONLY
#warning("SwiftNIO is enabled instead of Apple Networking")
#endif

@main
struct GlacioListsApp: SwiftUI.App {
    
    let realm: Realm
    let nodeManager: NodeManager
    let glacioCoordinator: GlacioRealmCoordinator

    #error("Add developerId here. Can be obtained from Glacio portal - DELETE THIS LINE BEFORE RUNNING")
    let developerId = ""

    let debugModel: DebugModel
    let nodeInfoModel: NodeInfoModel

    let chainId = GlacioConstants.defaultChain
    let glacioConfig: GlacioConfiguration
    
    init() {
        
        let seedNode = UserDefaults.standard.string(forKey: "seedNode")
        let chainDirPath = UserDefaults.standard.string(forKey: "chaindir") ?? "main"
        let port = UInt16(UserDefaults.standard.integer(forKey: "port"))

        let discoveryServiceAddress = UserDefaults.standard.string(forKey: "discoveryAddress")
        let disableDiscoverability = UserDefaults.standard.bool(forKey: "disableDiscoverability")

        let seedNodes = seedNode != nil ? [seedNode!] : []

        let discAddr = disableDiscoverability ? nil : discoveryServiceAddress // If discovery service disabled set to nil to disable it on NodeManager

        let forceProxying = false
        let enableP2P = true

        glacioConfig = GlacioConfiguration(chainDirPath: chainDirPath, port: port, seedNodes: seedNodes, discoverabilityServiceAddress: discAddr, proxyAllConnections: forceProxying, enableProxyRegistration: true, disablePeer2PeerConnections: !enableP2P)

        do {
            self.nodeManager = try NodeManager(developerId: developerId, config: glacioConfig)
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
