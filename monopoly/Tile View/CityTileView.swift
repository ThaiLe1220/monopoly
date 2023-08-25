//
//  CityTileView.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 25/08/2023.
//

import SwiftUI

struct CityTileView: View {
    @ObservedObject var cities:CityModel
    @ObservedObject var players:PlayerModel
    @Binding var showTileDetailedInfo: Bool
    @Binding var selectedTileId: Int
    
    var tiles:[TilePosition] = TilePositionModel().tiles
    var cityId: Int
    var cityColor: Color
    var backgroundColor: Color
    
    var rotatedAngle: Double {
        if cityId > 11 {return 180} else {return 0}
    }
    
    var body: some View {
        ZStack {
            ZStack (){
                Spacer()
                    .frame(width: 20, height: 10)
                    .background(backgroundColor)
                    .offset(x: -5, y: -25)
                
                Spacer()
                    .frame(width: 10, height: 10)
                    .background(backgroundColor)
                    .rotationEffect(Angle(degrees: 90))
                    .offset(x: -10, y: -15)
                
                Text("\(cities.cities[cityId].cityName)")
                    .frame(width: 60, height: 10)
                    .rotationEffect(Angle(degrees: -90 + rotatedAngle))
                    .font(.system(size: 8.5, weight: .medium, design: .default))
                    .foregroundColor(cityColor)
                    .offset(x: 10)
                
                if (cities.cities[cityId].currentLevel == 0) {
                    Text("\(cities.cities[cityId].rent) $")
                        .frame(width: 50, height: 10)
                        .rotationEffect(Angle(degrees: -90 + rotatedAngle))
                        .font(.system(size: 8.5, weight: .medium, design: .default))
                        .foregroundColor(.green)
                        .offset(x: 0, y: 5)
                }
                else {
                    Text("\(cities.cities[cityId].rent) $")
                        .frame(width: 50, height: 10)
                        .rotationEffect(Angle(degrees: -90))
                        .font(.system(size: 8.5, weight: .medium, design: .default))
                        .foregroundColor(.green)
                        .offset(x: 0, y: 5)
                }
                
                HStack (spacing: 0) {
                    if cities.cities[cityId].currentLevel == 1 {
                        Image(systemName: "flag.fill")
                            .frame(width: 10, height: 10)
                            .font(.system(size: 5, weight: .regular, design: .default))
                            .rotationEffect(Angle(degrees: -90))
                            .foregroundColor(Color(players.players[cities.cities[cityId].ownerId-1].color.rawValue))
                    }
                    
                    else if cities.cities[cityId].currentLevel > 1 && cities.cities[cityId].currentLevel < 5 {
                        ForEach(1..<cities.cities[cityId].currentLevel, id: \.self) { _ in
                            Image(systemName: "house.fill")
                                .frame(width: 10, height: 10)
                                .font(.system(size: 5, weight: .regular, design: .default))
                                .rotationEffect(Angle(degrees: -90))
                                .foregroundColor(Color(players.players[cities.cities[cityId].ownerId-1].color.rawValue))
                        }
                    }
                    else if cities.cities[cityId].currentLevel == 5 {
                        Image(systemName: "building.2.fill")
                            .frame(width: 10, height: 10)
                            .font(.system(size: 6, weight: .regular, design: .default))
                            .rotationEffect(Angle(degrees: -90))
                            .foregroundColor(Color(players.players[cities.cities[cityId].ownerId-1].color.rawValue))
                    }
                    else {
                        
                    }
                }
                .frame(width: 40, height: 10)
                .rotationEffect(Angle(degrees: 090))
                .foregroundColor(.green)
                .offset(x: -10, y: 10)
            }
            
        }
    }
}

struct CityTileView_Previews: PreviewProvider {
    static var previews: some View {
        CityTileView(cities: CityModel(), players: PlayerModel(), showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1), cityId: 1, cityColor: Color.purple, backgroundColor: Color.purple.opacity(0.7))
    }
}