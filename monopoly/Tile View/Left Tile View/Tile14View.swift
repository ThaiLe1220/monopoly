//
//  Tile14View.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct Tile14View: View {
    @Binding var showTileDetailedInfo: Bool
    @Binding var selectedTileId: Int
    
    var body: some View {
        ZStack {
            ZStack{
                Text("CHANCE")
                    .frame(width: 30, height: 10)
                    .border(.black, width: 0.3)
                    .font(.system(size: 7, weight: .ultraLight, design: .monospaced))
                
            }
            .frame(width: 30, height: 60)
            .border(.black, width: 0.2)
            .offset(x: -15, y: 150)
        }
    }
}

struct Tile14View_Previews: PreviewProvider {
    static var previews: some View {
        Tile14View(showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1))
    }
}