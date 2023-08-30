//
//  RightTileView.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct RightTileView: View {
    @ObservedObject var cities:CityModel
    @ObservedObject var players:PlayerModel
    
    @Binding var showTileDetailedInfo: Bool
    @Binding var selectedTileId: Int
    
    var tiles:[TilePosition] = TilePositionModel().tiles

    var body: some View {
         /// RIGHT TILES
         ZStack {
             Tile27View(showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 27 - WORLD TOUR
             Tile28View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 28 - LYON
             Tile29View(showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 29 - NICE BEACH
             Tile30View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 30 - PARIS
             Tile31View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 31- BORDEAUX
             Tile32View(showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 32 - CHANCE
             Tile33View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 33 - OSAKA
             Tile34View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 34 - TOKYO
             Tile35View(players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 35 - TAX
         }
         .frame(width: 360, height: 360)
         .rotationEffect(Angle(degrees: 270))
         .font(.system(size: 8, weight: .regular, design: .monospaced)) 
    }
}

struct RightTileView_Previews: PreviewProvider {
    static var previews: some View {
        RightTileView(cities: CityModel(), players: PlayerModel(), showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1))
    }
}
