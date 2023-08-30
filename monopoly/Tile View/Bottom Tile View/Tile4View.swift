//
//  Tile4View.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct Tile4View: View {
    @ObservedObject var players:PlayerModel
    @Binding var showTileDetailedInfo: Bool
    @Binding var selectedTileId: Int
    
    var body: some View {
        ZStack {
            ZStack{
                TaxTileView(players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
            }
            .frame(width: 30, height: 60)
            .offset(x: 15, y: 150)
        }
    }
}

struct Tile4View_Previews: PreviewProvider {
    static var previews: some View {
        Tile4View(players: PlayerModel(), showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1))
    }
}
