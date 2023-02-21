//
//  GlacioNodeObserver.swift
//  GlacioLists
//
//  Created by Peter Liddle on 2/21/23.
//

import Foundation
import GlacioSwift
import GlacioCore
import RealmSwift

enum DBUpdateError: Error {
    case databaseUnsynced
    case unknownRealmObject
}

class GlacioNodeObserver: NodeWatcher, ObservableObject {
 
    var node: GlacioCore.Node
    let realm: Realm
    var dApp: RealmChangeDApp
    
    var lastBlockUpdate: Int = -1
    
    let chainId: String = GlacioListConstants.chainId
    
    @Published var chainStatus: String = ""
    
    init(node: GlacioCore.Node, realm: Realm, chainId: String = GlacioListConstants.chainId) {
        self.node = node
        self.realm = realm
        self.dApp = node.app(appType: RealmChangeDApp.self)!
    }
    
    func createNodeObservers() throws {
        try node.blockAddSuccessCallback(forChain: chainId, callback: newBlockAdded(index:))
        
        node.syncCallback = { [self] syncedChainId in
            DispatchQueue.main.async {
                do {
                    guard self.chainId == syncedChainId else { return } // Ignore sync on other chains
                    try self.loadDBData(fomIndex: 0)
                }
                catch {
                    print("Error during sync callback: \(error)")
                }
            }
        }
    }
    
    func loadDBData(fomIndex index: Int) throws {
        try dApp.buildDB(fromBlock: index, chainId: chainId, forType: ChangeItem<ListItem>.self) { tx in
            
            do {
                print(tx)
                guard index == lastBlockUpdate + 1 else {
                    // Error db has become unsynced rebuild the database
                    throw DBUpdateError.databaseUnsynced
                }
                
                // Update database with the latest block
                guard let realmOb = tx.changeObj as? ListItem else { throw DBUpdateError.unknownRealmObject }
                try realm.write {
                    switch(tx.typeId) {
                    case .create:
                        guard realm.object(ofType: ListItem.self, forPrimaryKey: realmOb.id) == nil else { return } //Don't add if the record already exists
                        self.realm.add(realmOb)
                    case .update:
                        realm.add(realmOb, update: .modified)
                    case .delete:
                        guard let existingObj = realm.object(ofType: ListItem.self, forPrimaryKey: realmOb.id) else { return }
                        self.realm.delete(existingObj)
                    }
                }
            }
            catch {
                print(error)
                return
            }
        }
    }
    
    private func newBlockAdded(index: Int) {
        
        DispatchQueue.main.async { [self] in
            
            defer {
                lastBlockUpdate = index
            }
            
            do {
                try loadDBData(fomIndex: index)
            }
            catch {
                print(error)
            }
        }
    }
}
