//
//  RealmChangeObserver.swift
//  GlacioLists
//
//  Created by Peter Liddle on 2/21/23.
//

import Foundation
import RealmSwift
import GlacioSwift
import GlacioCore

struct GlacioListConstants {
    static let chainId = "glaciolist"
}

class RealmChangeObserver: RealmWatcher {
    
    var observers = [String : NotificationToken]()
    
    let realm: Realm
    
    let realmDApp: RealmChangeDApp
    
    let chainId: String
    
    init(realm: Realm, realmDApp: RealmChangeDApp, chainId: String = GlacioListConstants.chainId) {
        self.realm = realm
        self.realmDApp = realmDApp
        self.chainId = chainId
    }
    
    func createAndStartObservers() {
        let listItemWatcher = realm.objects(ListItem.self).observe() { changes in

            // Make sure we only watch updates. RealmCollectionChange.initial will give us the whole contents of the table on every start

            if case .update(_, deletions: _, insertions: _, modifications: _) = changes {
                let gChanges = self.realmChangeSetToGlacioChangeSet(changes: changes) //<RealmCollectionChange<Results<ListItem>>>(
                print(gChanges)
                do {
                    try self.realmDApp.commit(changes: gChanges, chainId: self.chainId)
                }
                catch {
                    print("Failed to commit changes: \(gChanges) on \(self.chainId)")
                }
            }
        }
        
        self.observers["\(ListItem.self)"] = listItemWatcher
    }
}
