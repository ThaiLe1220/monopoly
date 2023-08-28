//
//  Tile1View.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct Tile1View: View {
    @ObservedObject var cities:CityModel
    @ObservedObject var players:PlayerModel
    @Binding var showTileDetailedInfo: Bool
    @Binding var selectedTileId: Int
    
    var tiles:[TilePosition] = TilePositionModel().tiles
    
    var body: some View {
        ZStack {
            CityTileView(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId, cityId: 1, cityColor: .purple, backgroundColor: .purple.opacity(0.8))
                .frame(width: 30, height: 60)
                .offset(x: 105, y: 150)
                .onTapGesture {
                    
                }
        }
    }
}

struct Tile1View_Previews: PreviewProvider {
    static var previews: some View {
        Tile1View(cities: CityModel(), players: PlayerModel(), showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1))
    }
}
