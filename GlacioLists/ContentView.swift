//
//  ContentView.swift
//  GlacioLists
//
//  Created by Peter Liddle on 2/20/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ListView()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
