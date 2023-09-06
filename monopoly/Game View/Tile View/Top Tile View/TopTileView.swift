//
//  TopTileView.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct TopTileView: View {
    @ObservedObject var cities:CityModel
    @ObservedObject var beaches:BeachModel
    @ObservedObject var players:PlayerModel
    
    @Binding var showTileDetailedInfo: Bool
    @Binding var selectedTileId: Int
    
    var tiles:[TilePosition] = TilePositionModel().tiles

    var body: some View {
         /// TOP TILES
         ZStack {
             // TILE 18 - WORLD TOUR
             Tile18View(showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                 .onTapGesture {
                     showTileDetailedInfo = true
                     selectedTileId = 18
                     print(selectedTileId)
                 }
             
             // TILE 19 - LONDON
             Tile19View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                 .onTapGesture {
                     showTileDetailedInfo = true
                     selectedTileId = 19
                     print(selectedTileId)
                 }
             
             // TILE 20 - DEVON BEACH
             Tile20View(beaches: beaches, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                 .onTapGesture {
                     showTileDetailedInfo = true
                     selectedTileId = 20
                     print(selectedTileId)
                 }
             
             // TILE 21 - BATH
             Tile21View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                 .onTapGesture {
                     showTileDetailedInfo = true
                     selectedTileId = 21
                     print(selectedTileId)
                 }
             
             // TILE 22 - CAMBRIDGE
             Tile22View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                 .onTapGesture {
                     showTileDetailedInfo = true
                     selectedTileId = 22
                     print(selectedTileId)
                 }
             
             // TILE 23 - CHANCE
             Tile23View(showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                 .onTapGesture {
                     showTileDetailedInfo = true
                     selectedTileId = 23
                     print(selectedTileId)
                 }
             
             // TILE 24 - CHICAGO
             Tile24View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                 .onTapGesture {
                     showTileDetailedInfo = true
                     selectedTileId = 24
                     print(selectedTileId)
                 }
             
             // TILE 25 - LAS VEGAS
             Tile25View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                 .onTapGesture {
                     showTileDetailedInfo = true
                     selectedTileId = 25
                     print(selectedTileId)
                 }
             
             // TILE 26 - NEW YORK
             Tile26View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                 .onTapGesture {
                     showTileDetailedInfo = true
                     selectedTileId = 26
                     print(selectedTileId)
                 }
         }
         .frame(width: 360, height: 360)
         .rotationEffect(Angle(degrees: 180))
         .font(.system(size: 8, weight: .regular, design: .monospaced))
     }
}

struct TopTileView_Previews: PreviewProvider {
    static var previews: some View {
        TopTileView(cities: CityModel(), beaches: BeachModel(), players: PlayerModel(), showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1))
    }
}
