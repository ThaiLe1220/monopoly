//
//  BottomTileView.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct BottomTileView: View {
    var body: some View {
        /// BOTTOM TILES
        ZStack {
            Tile0View() // TILE 0 - START
            Tile1View() // TILE 1 - GRANDA
            Tile2View() // TILE 2 - SEVILLE
            Tile3View() // TILE 3 - MADRID
            Tile4View() // TILE 4 - TAX
            Tile5View() // TILE 5 - BALI BEACH
            Tile6View() // TILE 6 - HONG KONG
            Tile7View() // TILE 7 - BEIJING
            Tile8View() // TILE 8 - SHANGHAI
        }
        .frame(width: 360, height: 360)
        .rotationEffect(Angle(degrees: 0))
        .font(.system(size: 8, weight: .ultraLight, design: .monospaced))
    }
}

struct BottomTileView_Previews: PreviewProvider {
    static var previews: some View {
        BottomTileView()
    }
}
