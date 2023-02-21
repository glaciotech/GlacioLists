//
//  ListView.swift
//  GlacioLists
//
//  Created by Peter Liddle on 2/20/23.
//

import Foundation
import SwiftUI
import RealmSwift

struct ListView: View {
    
    @Environment(\.realm) var realm: Realm
    @ObservedResults(ListItem.self) var listItems
    
    @State var itemTextToAdd: String = ""
    
    var body: some View {
        VStack {
            List {
                ForEach(listItems) { item in
                    Label<Text, Image>(title: { Text(item.text) }, icon: { Image(systemName: "circle") })
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let item = listItems[index]
                        try? realm.write {
                            guard let delItem = realm.objects(ListItem.self).first(where: { $0.id == item.id }) else { return }
                            realm.delete(delItem)
                        }
                    }
                }
            }
            HStack {
                TextField("Add item", text: $itemTextToAdd)
                Button {
                    guard !itemTextToAdd.isEmpty else { return }
                    
                    // As this is just a example app if it fails just leave it and don't add
                    try? realm.write {
                        let newItem = ListItem(value: ["text": itemTextToAdd])
                        realm.add(newItem)
                        itemTextToAdd = ""
                    }
                } label: {
                    Label("Add", systemImage: "plus.circle")
                        .foregroundColor(.blue)
                }
            }.padding(.all, 5)
        }
    }
}

struct ListView_Previews: PreviewProvider {

    static let mockItems = [ListItem(value: ["text": "A"]), ListItem(value: ["text": "B"]), ListItem(value: ["text": "C"])]
    
    static let mockRealm = {
        let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "mockRealmData", deleteRealmIfMigrationNeeded: true))
        mockItems.forEach({ item in try! realm.write({ realm.add(item) }) })
        return realm
    }()

    static var previews: some View {
        ListView()
            .environment(\.realm, mockRealm)
    }
}

