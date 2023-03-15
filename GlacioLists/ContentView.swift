//
//  ContentView.swift
//  GlacioLists
//
//  Created by Peter Liddle on 2/20/23.
//

import SwiftUI

struct ContentView: View {
    
    @State var chainId: String
    
    var body: some View {
        VStack {
            Text(chainId)
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
