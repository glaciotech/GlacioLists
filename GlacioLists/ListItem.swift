//
//  ListItem.swift
//  GlacioLists
//
//  Created by Peter Liddle on 2/20/23.
//

import Foundation
import RealmSwift
import SwiftUI
import GlacioSwift

class ListItem: Object, Identifiable, GlacioRealmObject {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var dateTime: Date = Date()
    @objc dynamic var text: String = ""
    
    override class func primaryKey() -> String? {
        "id"
    }
}
