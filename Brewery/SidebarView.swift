//
//  SidebarView.swift
//  Brewery
//
//  Created by Pongt Chia on 6/6/25.
//

import SwiftUI

struct SidebarView: View {
    @Binding var selection: BrewTerminology?
    
    var body: some View {
//        List(["formulae", "cask"], id: \.self, selection: $selection) {
//            Text($0)
//        }
//        .listStyle(.sidebar)
        
        List(selection: $selection) {
            ForEach(BrewTerminology.allCases, id: \.self) {
                Text($0.rawValue)
            }
        }
    }
}

#Preview {
    SidebarView(selection: .constant(BrewTerminology.formulae))
}
