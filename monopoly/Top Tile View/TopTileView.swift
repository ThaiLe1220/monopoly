//
//  TopTileView.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct TopTileView: View {
    var body: some View {
         /// TOP TILES
         ZStack {
             Tile18View() // TILE 18 - WORLD TOUR
             Tile19View() // TILE 19 - LONDON
             Tile20View() // TILE 20 - DEVON BEACH
             Tile21View() // TILE 21 - BATH
             Tile22View() // TILE 22 - CAMBRIDGE
             Tile23View() // TILE 23 - CHANCE
             Tile24View() // TILE 24 - CHICAGO
             Tile25View() // TILE 25 - LAS VEGAS
             Tile26View() // TILE 26 - NEW YORK
         }
         .frame(width: 360, height: 360)
         .rotationEffect(Angle(degrees: 180))
         .font(.system(size: 8, weight: .regular, design: .monospaced))
     }
}

struct TopTileView_Previews: PreviewProvider {
    static var previews: some View {
        TopTileView()
    }
}
