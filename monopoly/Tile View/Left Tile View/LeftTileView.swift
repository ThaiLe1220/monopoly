//
//  LeftTileView.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct LeftTileView: View {
    @ObservedObject var cities:CityModel
    @ObservedObject var beaches:BeachModel
    @ObservedObject var players:PlayerModel

    @Binding var showTileDetailedInfo: Bool
    @Binding var selectedTileId: Int
    
    var tiles:[TilePosition] = TilePositionModel().tiles

    var body: some View {
        /// LEFT TILES
        ZStack {
            
            // TILE 9 - LOST ISLAND
            Tile9View(showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                .onTapGesture {
                    showTileDetailedInfo = true
                    selectedTileId = 9
                    print(selectedTileId)
                }
            
            // TILE 10 - VENICE
            Tile10View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                .onTapGesture {
                    showTileDetailedInfo = true
                    selectedTileId = 10
                    print(selectedTileId)
                }
            
            // TILE 11 - FREE MONEY
            Tile11View(showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                .onTapGesture {
                    showTileDetailedInfo = true
                    selectedTileId = 11
                    print(selectedTileId)
                }
            
            // TILE 12 - MILAN
            Tile12View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                .onTapGesture {
                    showTileDetailedInfo = true
                    selectedTileId = 12
                    print(selectedTileId)
                }
            
            // TILE 13 - ROME
            Tile13View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                .onTapGesture {
                    showTileDetailedInfo = true
                    selectedTileId = 13
                    print(selectedTileId)
                }
            
            // TILE 14 - CHANCE ?
            Tile14View(showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                .onTapGesture {
                    showTileDetailedInfo = true
                    selectedTileId = 14
                    print(selectedTileId)
                }
            
            // TILE 15 - HAMBURG
            Tile15View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                .onTapGesture {
                    showTileDetailedInfo = true
                    selectedTileId = 15
                    print(selectedTileId)
                }
            
            // TILE 16 - CYPRUS BEACH
            Tile16View(beaches: beaches, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                .onTapGesture {
                    showTileDetailedInfo = true
                    selectedTileId = 16
                    print(selectedTileId)
                }
            
            // TILE 17- BERLIN
            Tile17View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                .onTapGesture {
                    showTileDetailedInfo = true
                    selectedTileId = 17
                    print(selectedTileId)
                }
        }
        .frame(width: 360, height: 360)
        .rotationEffect(Angle(degrees: 90))
        .font(.system(size: 8, weight: .regular, design: .monospaced))
    }   
}

struct LeftTileView_Previews: PreviewProvider {
    static var previews: some View {
        LeftTileView(cities: CityModel(), beaches: BeachModel(), players: PlayerModel(), showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1))
    }
}
