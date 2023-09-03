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
                    .frame(width: 30, height: 10)
                    .background(backgroundColor)
                    .offset(x: 0, y: -25)
                
                Text("\(cities.cities[cityId].cityName)")
                    .frame(width: 50, height: 10)
                    .rotationEffect(Angle(degrees: -90 + rotatedAngle))
                    .font(.system(size: 7.5, weight: .medium, design: .default))
                    .foregroundColor(cityColor)
                    .offset(x: 10, y: 5)
                
                Spacer()
                    .frame(width: 30, height: 1.4)
                    .background(.black.opacity(0.7))
                    .offset(y:-20)
                
                Spacer()
                    .frame(width: 1.4, height: 61.4)
                    .background(.black.opacity(0.7))
                    .offset(x:-15)
                Spacer()
                    .frame(width: 1.4, height: 61.4)
                    .background(.black.opacity(0.7))
                    .offset(x:15)
                Spacer()
                    .frame(width: 30, height: 1.4)
                    .background(.black.opacity(0.7))
                    .offset(y:30)
                Spacer()
                    .frame(width: 30, height: 1.4)
                    .background(.black.opacity(0.7))
                    .offset(y:-30)
                
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
                        .rotationEffect(Angle(degrees: -90 + rotatedAngle))
                        .font(.system(size: 8.5, weight: .medium, design: .default))
                        .foregroundColor(.green)
                        .offset(x: 0, y: 5)
                }
                
                /// OWNER IDENTIFICATION VIEW
                ZStack {
                    if cities.cities[cityId].currentLevel == 1 {
                        Image(systemName: "flag.fill")
                            .frame(width: 10, height: 10)
                            .font(.system(size: 8, weight: .regular, design: .default))
                            .rotationEffect(Angle(degrees: 90 * rotatedAngle))
                            .foregroundColor(Color(players.players[cities.cities[cityId].ownerId-1].color.rawValue))
                    }
                    else if cities.cities[cityId].currentLevel > 1 && cities.cities[cityId].currentLevel < 5 {
                        Image(systemName: "house.and.flag.fill")
                            .frame(width: 10, height: 10)
                            .font(.system(size: 8, weight: .regular, design: .default))
                            .rotationEffect(Angle(degrees: 90 * rotatedAngle))
                            .foregroundColor(Color(players.players[cities.cities[cityId].ownerId-1].color.rawValue))
                    
                    }
                    else if cities.cities[cityId].currentLevel == 5 {
                        Image(systemName: "building.2.fill")
                            .frame(width: 10, height: 10)
                            .font(.system(size: 8, weight: .regular, design: .default))
                            .rotationEffect(Angle(degrees: 90 * rotatedAngle))
                            .foregroundColor(Color(players.players[cities.cities[cityId].ownerId-1].color.rawValue))
                    }
                }
                .offset(y: -35)
            }
        }
    }
}

struct CityTileView_Previews: PreviewProvider {
    static var previews: some View {
        CityTileView(cities: CityModel(), players: PlayerModel(), showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1), cityId: 1, cityColor: Color.purple, backgroundColor: Color.purple.opacity(0.7))
    }
}
