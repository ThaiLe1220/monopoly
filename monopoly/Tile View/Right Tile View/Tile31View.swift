//
//  Tile31View.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct Tile31View: View {
    @ObservedObject var cities:CityModel
    @ObservedObject var players:PlayerModel
    @Binding var showTileDetailedInfo: Bool
    @Binding var selectedTileId: Int
    
    var body: some View {
        ZStack {
            CityTileView(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId, cityId: 20, cityColor: .green, backgroundColor: .green.opacity(0.9))
                .frame(width: 30, height: 60)
                .border(.black, width: 0.2)
                .offset(x: 15, y: 150)
        }
    }
}

struct Tile31View_Previews: PreviewProvider {
    static var previews: some View {
        Tile31View(cities: CityModel(), players: PlayerModel(), showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1))
    }
}