//
//  RightTileView.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct RightTileView: View {
    @ObservedObject var cities:CityModel
    @ObservedObject var beaches:BeachModel
    @ObservedObject var players:PlayerModel
    
    @Binding var showTileDetailedInfo: Bool
    @Binding var selectedTileId: Int
    
    var tiles:[TilePosition] = TilePositionModel().tiles

    var body: some View {
         /// RIGHT TILES
         ZStack {
             // TILE 27 - WORLD TOUR
             Tile27View(showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                 .onTapGesture {
                     showTileDetailedInfo = true
                     selectedTileId = 27
                     print(selectedTileId)
                 }
             
             // TILE 28 - LYON
             Tile28View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                 .onTapGesture {
                     showTileDetailedInfo = true
                     selectedTileId = 28
                     print(selectedTileId)
                 }
             
             // TILE 29 - NICE BEACH
             Tile29View(beaches: beaches, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                 .onTapGesture {
                     showTileDetailedInfo = true
                     selectedTileId = 29
                     print(selectedTileId)
                 }
             
             // TILE 30 - PARIS
             Tile30View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                 .onTapGesture {
                     showTileDetailedInfo = true
                     selectedTileId = 30
                     print(selectedTileId)
                 }
             
             // TILE 31- BORDEAUX
             Tile31View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                 .onTapGesture {
                     showTileDetailedInfo = true
                     selectedTileId = 31
                     print(selectedTileId)
                 }
             
             // TILE 32 - CHANCE
             Tile32View(showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                 .onTapGesture {
                     showTileDetailedInfo = true
                     selectedTileId = 32
                     print(selectedTileId)
                 }
             
             // TILE 33 - OSAKA
             Tile33View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                 .onTapGesture {
                     showTileDetailedInfo = true
                     selectedTileId = 33
                     print(selectedTileId)
                 }
             
             // TILE 34 - TOKYO
             Tile34View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                 .onTapGesture {
                     showTileDetailedInfo = true
                     selectedTileId = 34
                     print(selectedTileId)
                 }
             
             // TILE 35 - TAX
             Tile35View(players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                 .onTapGesture {
                     showTileDetailedInfo = true
                     selectedTileId = 35
                     print(selectedTileId)
                 }
         }
         .frame(width: 360, height: 360)
         .rotationEffect(Angle(degrees: 270))
         .font(.system(size: 8, weight: .regular, design: .monospaced)) 
    }
}

struct RightTileView_Previews: PreviewProvider {
    static var previews: some View {
        RightTileView(cities: CityModel(), beaches: BeachModel(), players: PlayerModel(), showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1))
    }
}
