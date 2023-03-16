//
//  ContentView.swift
//  GlacioLists
//
//  Created by Peter Liddle on 2/20/23.
//

import SwiftUI
import GlacioSwift

struct ContentView: View {
    
    @State var chainId: String

    @State var selectedView: Int = 0

    var body: some View {
        TabView(selection: $selectedView) {
            listView.tabItem { Text("List") }.tag(1)
            debugView.tabItem { Text("Debug") }.tag(2)
        }
    }

    var debugView: some View {
        GlacioDebugView()
            .padding()
    }

    var listView: some View {
        VStack {
            Text(chainId)
            NodeInfoView()
            ListView()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(chainId: "Test-Chain")
    }
}
