//
//  RightTileView.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct RightTileView: View {
    var body: some View {
         /// RIGHT TILES
         ZStack {
             Tile27View() // TILE 27 - WORLD TOUR
             Tile28View() // TILE 28 - LYON
             Tile29View() // TILE 29 - NICE BEACH
             Tile30View() // TILE 30 - PARIS
             Tile31View() // TILE 31- BORDEAUX
             Tile32View() // TILE 32 - CHANCE
             Tile33View() // TILE 33 - OSAKA
             Tile34View() // TILE 34 - TOKYO
             Tile35View() // TILE 35 - TAX
         }
         .frame(width: 360, height: 360)
         .rotationEffect(Angle(degrees: 270))
         .font(.system(size: 8, weight: .regular, design: .monospaced)) 
    }
}

struct RightTileView_Previews: PreviewProvider {
    static var previews: some View {
        RightTileView()
    }
}
