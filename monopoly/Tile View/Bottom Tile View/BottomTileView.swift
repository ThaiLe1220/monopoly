//
//  BottomTileView.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct BottomTileView: View {
    @ObservedObject var cities:CityModel
    @ObservedObject var players:PlayerModel

    @Binding var showTileDetailedInfo: Bool
    @Binding var selectedTileId: Int
    
    var tiles:[TilePosition] = TilePositionModel().tiles

    var body: some View {
        /// BOTTOM TILES
        ZStack {
            Tile0View(showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 0 - START
            Tile1View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 1 - GRANDA
            Tile2View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 2 - SEVILLE
            Tile3View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 3 - MADRID
            Tile4View(players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 4 - TAX
            Tile5View(showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 5 - BALI BEACH
            Tile6View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 6 - HONG KONG
            Tile7View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 7 - BEIJING
            Tile8View(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId) // TILE 8 - SHANGHAI
        }
        .frame(width: 360, height: 360)
        .rotationEffect(Angle(degrees: 0))
        .font(.system(size: 8, weight: .ultraLight, design: .monospaced))
    }
}

struct BottomTileView_Previews: PreviewProvider {
    static var previews: some View {
        BottomTileView(cities: CityModel(), players: PlayerModel(), showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1))
    }
}
