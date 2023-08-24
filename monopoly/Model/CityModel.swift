//
//  CityModel.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 23/08/2023.
//

import Foundation
import CoreLocation

class CityModel: ObservableObject{
    @Published var cities: [City] = []
    
    init(){ cities = decodeFromJson(file: "City.json") }
        
    func decodeFromJson(file: String) -> [City] {
        print("decodeFromJson invoked, filename: \(file)")

        if let file = Bundle.main.url(forResource: file, withExtension: nil){
            if let data = try? Data(contentsOf: file) {
                do {
                    let decoded = try JSONDecoder().decode([City].self, from: data)
                    return decoded
                } catch let error {
                    fatalError("Failed to decode JSON: \(error)")
                }
            }
        } else {
            fatalError("Couldn't load \(file) file")
        }
        
        return [ ] as [City]
    }
    
    func buyProperty (player: inout Player, tickedBuyingOption : Set<Int>) {
        print("buyProperty invoked by Player: \(player.id)", terminator: " ")
        if let index = cities.firstIndex(where: {$0.tileId == player.tilePositionId}) {
            print("in city: \(cities[index].id)", terminator: " ")
            let n = tickedBuyingOption.max() ?? 0
        
            for _ in cities[index].currentLevel..<n { // loop from city current level to the level chosen by player
                if player.money >= cities[index].cost && cities[index].ownerId == -1 { //sufficient player money && city unowned
                    cities[index].ownerId = player.id
                    player.tilePropertyIds.append(cities[index].tileId)
                    cities[index].totalCost += cities[index].cost
                    player.money -= cities[index].cost
                    cities[index].currentLevel = 1
                    print("successfully bought")
                }
                else if player.money >= cities[index].cost && cities[index].ownerId == player.id { //sufficient player money && city owned
                    cities[index].totalCost += cities[index].cost
                    player.money -= cities[index].cost
                    cities[index].currentLevel += 1
                    print("successfully upgraded")
                }
                else {
                    print(", failed to bought or upgrade ")
                }
            }
        }
        else{
            print("but can not find city")
        }
    }
    
    func sellProperty (city: inout City, player: inout Player) -> Bool{
        print("sellProperty invoked by Player: \(player.id)", terminator: " ")
        if let index = cities.firstIndex(where: {$0.tileId == player.tilePositionId}) {
            print("in city: \(cities[index].id)", terminator: " ")
            if (player.tilePropertyIds.contains(cities[index].tileId)){
                cities[index].ownerId = -1
                player.tilePropertyIds = player.tilePropertyIds.filter{$0 != cities[index].tileId}
                city.currentLevel = 0
                city.totalCost = 0
                player.money += city.totalCost
                print("successfully sold")
                return true
            }
            print("but failed")
            return false
        }
        print("but can not find city")
        return false
    }
    
    
}
