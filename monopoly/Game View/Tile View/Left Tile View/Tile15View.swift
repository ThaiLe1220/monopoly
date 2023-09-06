//
//  Tile15View.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct Tile15View: View {
    @ObservedObject var cities:CityModel
    @ObservedObject var players:PlayerModel
    @Binding var showTileDetailedInfo: Bool
    @Binding var selectedTileId: Int
    
    var body: some View {
        ZStack {
            CityTileView(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId, cityId: 10, cityColor: .orange, backgroundColor: .orange.opacity(0.6))
                .frame(width: 30, height: 60)
                .border(.black, width: 0.2)
                .offset(x: -45, y: 150)
        }
    }
}

struct Tile15View_Previews: PreviewProvider {
    static var previews: some View {
        Tile15View(cities: CityModel(), players: PlayerModel(), showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1))
    }
}
