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
        
    func decodeFromJson (file: String) -> [City] {
//        print("decodeFromJson invoked, filename: \(file)")

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
    
    // Buy unowned Property and Upgrade owned Property by game player
    func buyCity (player: inout Player, options:  Set<Int>) -> Bool {
        var bought = false
        print("buyCity invoked by Player: \(player.id)", terminator: " ")
        if let index = cities.firstIndex(where: {$0.tileId == player.tilePositionId}) {
            print("in city: \(cities[index].id),", terminator: " ")
            let n = options.max() ?? 0
            
            for _ in cities[index].currentLevel..<n { // loop from city current level to the level chosen by player
                if player.money >= cities[index].cost && cities[index].ownerId == -1 { //sufficient player money && city unowned
                    bought = true
                    cities[index].ownerId = player.id
                    player.tilePropertyIds.append(cities[index].tileId)
                    cities[index].totalCost += cities[index].cost
                    player.money -= cities[index].cost
                    cities[index].currentLevel = 1
                    print("bought", terminator: " ")
                }
                
                else if player.money >= cities[index].cost && cities[index].ownerId == player.id { //sufficient player money && city owned
                    cities[index].totalCost += cities[index].cost
                    player.money -= cities[index].cost
                    cities[index].currentLevel += 1
                    print("upgraded", terminator: " ")
                }
                
                else { print(", but failed to bought or upgrade ") }
            }
            print("")
        }
        
        else { print("but can not find city") }
        
        return bought
    }
    
    // Autimatically Buy unowned Property and Upgrade owned Property by game player
    func buyCityAutomatically (player: inout Player, totalBuyingCost: inout Int) -> Bool {
        var bought = false
        print("buyCityAutomatically invoked by Player: \(player.id),", terminator: " ")
        if let index = cities.firstIndex(where: {$0.tileId == player.tilePositionId}) {
            print("in city: \(cities[index].id)", terminator: " ")

            // always bought if sufficient player money && city unowned
            if cities[index].currentLevel == 0 {
                if player.money >= cities[index].cost && cities[index].ownerId == -1 { //sufficient player money && city unowned
                    bought = true
                    cities[index].ownerId = player.id
                    player.tilePropertyIds.append(cities[index].tileId)
                    cities[index].totalCost += cities[index].cost
                    player.money -= cities[index].cost
                    totalBuyingCost += cities[index].cost
                    cities[index].currentLevel = 1
                    print("bought", terminator: " ")
                }
            }
            
            // always upgrade twice from 1 to level 3 if sufficient player money && city owned
            if cities[index].currentLevel <= 2 && cities[index].currentLevel > 0  {
                for _ in 1...2 {
                    if player.money * 8/10 >= cities[index].cost && cities[index].ownerId == player.id { //sufficient player money && city owned
                        cities[index].totalCost += cities[index].cost
                        player.money -= cities[index].cost
                        totalBuyingCost += cities[index].cost
                        cities[index].currentLevel += 1
                        print("upgraded", terminator: " ")
                    }
                }
            }
            
            // from level 3 onward, only upgrade by 1 level if sufficient player money && city owned
            else if cities[index].currentLevel <= 4 && cities[index].currentLevel > 2 {
                if player.money * 9/10 >= cities[index].cost && cities[index].ownerId == player.id { //sufficient player money && city owned
                    cities[index].totalCost += cities[index].cost
                    player.money -= cities[index].cost
                    totalBuyingCost += cities[index].cost
                    cities[index].currentLevel += 1
                    print("upgraded", terminator: " ")
                }
            }
            
            else if cities[index].currentLevel == 5 { print("already max upgraded") }
            
            else { print(", but failed to bought or upgrade ") }
            print("")
        }
        
        else {  print("but can not find city") }
        
        return bought
    }
    
    // Sell Property owned by game player
    func sellCity (city: inout City, player: inout Player) -> Bool{
        print("sellCity invoked by Player: \(player.id),", terminator: " ")
        if let index = cities.firstIndex(where: {$0.tileId == player.tilePositionId}) {
            print("in city: \(cities[index].id)", terminator: " ")
            if (player.tilePropertyIds.contains(cities[index].tileId)){
                cities[index].ownerId = -1
                player.tilePropertyIds = player.tilePropertyIds.filter{$0 != cities[index].tileId}
                city.currentLevel = 0
                city.totalCost = 0
                player.money += city.totalCost
                print("sold")
                return true
            }
            print("but failed")
            return false
        }
        print("but can not find city")
        return false
    }
    
    // Update Ticket Buying Set using game player city level at current position
    func updateCityBuyingOption(player: Player, options: inout Set<Int>) {
        print("updateCityBuyingOption invoked by Player: \(player.id),", terminator: " ")
        if let index = cities.firstIndex(where: {$0.tileId == player.tilePositionId}) {
            print("in city: \(cities[index].id)", terminator: " ")
            options.removeAll()

            if (cities[index].currentLevel > 0) {
                for option in 1...cities[index].currentLevel { options.insert(option) }
                print(", level \(cities[index].currentLevel)")
            }
            
            else { print(", level 0") }
        }
        
        else{ print("but can not find city") }
    }
    
}
