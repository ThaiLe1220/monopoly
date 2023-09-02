//
//  BottomTileView.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct BottomTileView: View {
    @ObservedObject var cities:CityModel
    @ObservedObject var beaches:BeachModel
    @ObservedObject var players:PlayerModel

    @Binding var showTileDetailedInfo: Bool
    @Binding var selectedTileId: Int
    
    var tiles:[TilePosition] = TilePositionModel().tiles

    var body: some View {
        /// BOTTOM TILES
        ZStack {
            // TILE 0 - START
            Tile0View(showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                .onTapGesture {
                    showTileDetailedInfo = true
                    selectedTileId = 0
                    print(selectedTileId)
                }
            
            // TILE 1 - GRANDA
            Tile1View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                .onTapGesture {
                    showTileDetailedInfo = true
                    selectedTileId = 1
                    print(selectedTileId)
                }
            
            // TILE 2 - SEVILLE
            Tile2View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                .onTapGesture {
                    showTileDetailedInfo = true
                    selectedTileId = 2
                    print(selectedTileId)
                }
            
            // TILE 3 - MADRID
            Tile3View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                .onTapGesture {
                    showTileDetailedInfo = true
                    selectedTileId = 3
                    print(selectedTileId)
                }
            
            // TILE 4 - TAX
            Tile4View(players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                .onTapGesture {
                    showTileDetailedInfo = true
                    selectedTileId = 4
                    print(selectedTileId)
                }
            
            // TILE 5 - BALI BEACH
            Tile5View(beaches: beaches, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                .onTapGesture {
                    showTileDetailedInfo = true
                    selectedTileId = 5
                    print(selectedTileId)
                }
            
            // TILE 6 - HONG KONG
            Tile6View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                .onTapGesture {
                    showTileDetailedInfo = true
                    selectedTileId = 6
                    print(selectedTileId)
                }
            
            // TILE 7 - BEIJING
            Tile7View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                .onTapGesture {
                    showTileDetailedInfo = true
                    selectedTileId = 7
                    print(selectedTileId)
                }
                 
            // TILE 8 - SHANGHAI
            Tile8View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                .onTapGesture {
                    showTileDetailedInfo = true
                    selectedTileId = 8
                    print(selectedTileId)
                }
        }
        .frame(width: 360, height: 360)
        .rotationEffect(Angle(degrees: 0))
        .font(.system(size: 8, weight: .ultraLight, design: .monospaced))
    }
}

struct BottomTileView_Previews: PreviewProvider {
    static var previews: some View {
        BottomTileView(cities: CityModel(), beaches: BeachModel(), players: PlayerModel(), showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1))
    }
}
