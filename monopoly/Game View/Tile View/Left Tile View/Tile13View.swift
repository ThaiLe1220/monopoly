
/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 2
  Author: Le Hong Thai
  ID: s3752577
  Created  date: 16/08/2023
  Last modified: 8/09/2023
  Acknowledgement: Acknowledge the resources that you use here.
*/


import SwiftUI

struct Tile13View: View {
    @ObservedObject var cities:CityModel
    @ObservedObject var players:PlayerModel
    @Binding var showTileDetailedInfo: Bool
    @Binding var selectedTileId: Int
    
    var body: some View {
        ZStack {
            CityTileView(cities: cities, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId, cityId: 9, cityColor: .pink, backgroundColor: .pink.opacity(0.6))
                .frame(width: 30, height: 60)
                .border(.black, width: 0.2)
                .offset(x: 15, y: 150)
        }
    }
}

struct Tile13View_Previews: PreviewProvider {
    static var previews: some View {
        Tile13View(cities: CityModel(), players: PlayerModel(), showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1))
    }
}
