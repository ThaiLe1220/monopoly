//
//  LeftTileView.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct LeftTileView: View {
    var body: some View {
        /// LEFT TILES
        ZStack {
            Tile9View() // TILE 9 - LOST ISLAND
            Tile10View() // TILE 10 - VENICE
            Tile11View() // TILE 11 - FREE MONEY
            Tile12View() // TILE 12 - MILAN
            Tile13View() // TILE 13 - ROME
            Tile14View() // TILE 14 - CHANCE ?
            Tile15View() // TILE 15 - HAMBURG
            Tile16View() // TILE 16 - CYPRUS BEACH
            Tile17View() // TILE 17- BERLIN
        }
        .frame(width: 360, height: 360)
        .rotationEffect(Angle(degrees: 90))
        .font(.system(size: 8, weight: .regular, design: .monospaced))
    }   
}

struct LeftTileView_Previews: PreviewProvider {
    static var previews: some View {
        LeftTileView()
    }
}
