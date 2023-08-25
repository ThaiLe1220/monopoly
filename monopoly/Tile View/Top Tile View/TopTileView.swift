//
//  TopTileView.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct TopTileView: View {
    @ObservedObject var cities:CityModel
    @ObservedObject var players:PlayerModel
    @Binding var showTileDetailedInfo: Bool
    @Binding var selectedTileId: Int
    
    var tiles:[TilePosition] = TilePositionModel().tiles

    var body: some View {
         /// TOP TILES
         ZStack {
             Tile18View(showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 18 - WORLD TOUR
             Tile19View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 19 - LONDON
             Tile20View(showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 20 - DEVON BEACH
             Tile21View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 21 - BATH
             Tile22View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 22 - CAMBRIDGE
             Tile23View(showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 23 - CHANCE
             Tile24View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 24 - CHICAGO
             Tile25View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 25 - LAS VEGAS
             Tile26View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 26 - NEW YORK
         }
         .frame(width: 360, height: 360)
         .rotationEffect(Angle(degrees: 180))
         .font(.system(size: 8, weight: .regular, design: .monospaced))
     }
}

struct TopTileView_Previews: PreviewProvider {
    static var previews: some View {
        TopTileView(cities: CityModel(), players: PlayerModel(), showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1))
    }
}
