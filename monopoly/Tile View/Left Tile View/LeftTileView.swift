//
//  LeftTileView.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct LeftTileView: View {
    @ObservedObject var cities:CityModel
    @ObservedObject var players:PlayerModel

    @Binding var showTileDetailedInfo: Bool
    @Binding var selectedTileId: Int
    
    var tiles:[TilePosition] = TilePositionModel().tiles

    var body: some View {
        /// LEFT TILES
        ZStack {
            Tile9View(showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 9 - LOST ISLAND
            Tile10View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 10 - VENICE
            Tile11View(showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 11 - FREE MONEY
            Tile12View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 12 - MILAN
            Tile13View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 13 - ROME
            Tile14View(showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 14 - CHANCE ?
            Tile15View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 15 - HAMBURG
            Tile16View(showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 16 - CYPRUS BEACH
            Tile17View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 17- BERLIN
        }
        .frame(width: 360, height: 360)
        .rotationEffect(Angle(degrees: 90))
        .font(.system(size: 8, weight: .regular, design: .monospaced))
    }   
}

struct LeftTileView_Previews: PreviewProvider {
    static var previews: some View {
        LeftTileView(cities: CityModel(), players: PlayerModel(), showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1))
    }
}
