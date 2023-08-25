//
//  Tile8View.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct Tile8View: View {
    @ObservedObject var cities:CityModel
    @ObservedObject var players:PlayerModel
    @Binding var showTileDetailedInfo: Bool
    @Binding var selectedTileId: Int
    
    var tiles:[TilePosition] = TilePositionModel().tiles
    
    var body: some View {
        ZStack {
            CityTileView(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId, cityId: 6, cityColor: .blue.opacity(0.5), backgroundColor: .blue.opacity(0.3))
                .frame(width: 30, height: 60)
                .border(.black, width: 0.2)
                .offset(x: -105, y: 150)
        }
        
    }
}

struct Tile8View_Previews: PreviewProvider {
    static var previews: some View {
        Tile8View(cities: CityModel(), players: PlayerModel(), showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1))
    }
}