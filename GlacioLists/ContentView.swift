//
//  ContentView.swift
//  GlacioLists
//
//  Created by Peter Liddle on 2/20/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var glacioObserver: GlacioNodeObserver
    
    var body: some View {
        VStack {
            HStack {
                
                let imageName: () -> String = {
                    if glacioObserver.chainStatus == "synced" {
                        return "square.fill.and.line.vertical.square.fill"
                    }
                    else {
                        return "square.and.line.vertical.and.square"
                    }
                }
               
                Label(glacioObserver.chainStatus.capitalized, systemImage: imageName())
            }
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
