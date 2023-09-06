//
//  Tile16View.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct Tile16View: View {
    @ObservedObject var beaches:BeachModel
    @ObservedObject var players:PlayerModel
    
    @Binding var showTileDetailedInfo: Bool
    @Binding var selectedTileId: Int
    
    var body: some View {
        ZStack {
            ZStack{
                BeachTileView(beaches: beaches, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId, beachId: 2)
            }
            .frame(width: 30, height: 60)
            .background(.brown.opacity(0.05))
            .offset(x: -75, y: 150)
        }
    }
}

struct Tile16View_Previews: PreviewProvider {
    static var previews: some View {
        Tile16View(beaches: BeachModel(), players: PlayerModel(), showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1))
    }
}
