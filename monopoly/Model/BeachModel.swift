//
//  BeachModel.swift
//  monopoly
//
//  Created by Thai, Le Hong on 30/08/2023.
//

import Foundation
import CoreLocation

class BeachModel: ObservableObject{
    @Published var beaches: [Beach] = []
    
    init(){ beaches = decodeFromJson(file: "Beach.json") }
        
    func decodeFromJson(file: String) -> [Beach] {
//        print("decodeFromJson invoked, filename: \(file)")

        if let file = Bundle.main.url(forResource: file, withExtension: nil){
            if let data = try? Data(contentsOf: file) {
                do {
                    let decoded = try JSONDecoder().decode([Beach].self, from: data)
                    return decoded
                } catch let error {
                    fatalError("Failed to decode JSON: \(error)")
                }
            }
        } else {
            fatalError("Couldn't load \(file) file")
        }
        
        return [ ] as [Beach]
    }
    
    // Buy unowned Property and Upgrade owned Property by game player
    func buyBeach (player: inout Player, options:  Set<Int>) {
        print("buyBeach invoked by Player: \(player.id)", terminator: " ")
        if let index = beaches.firstIndex(where: {$0.tileId == player.tilePositionId}) {
            print("in beach: \(beaches[index].id),", terminator: " ")
            let n = options.max() ?? 0
            
            for _ in beaches[index].currentLevel..<n { // loop from city current level to the level chosen by player
                if player.money >= beaches[index].cost && beaches[index].ownerId == -1 { //sufficient player money && city unowned
                    beaches[index].ownerId = player.id
                    player.tilePropertyIds.append(beaches[index].tileId)
                    player.money -= beaches[index].cost
                    beaches[index].currentLevel = 1
                    print("bought", terminator: " ")
                }
                
//                else if player.money >= cities[index].cost && cities[index].ownerId == player.id { //sufficient player money && city owned
//                    cities[index].totalCost += cities[index].cost
//                    player.money -= cities[index].cost
//                    cities[index].currentLevel += 1
//                    print("upgraded", terminator: " ")
//                }
                
                else { print(", but failed to bought") }
            }
            print("")
        }
        
        else { print("but can not find beach") }
    }
    
    // Autimatically Buy unowned Property and Upgrade owned Property by game player
//    func buyBeachAutomatically (player: inout Player) {
//        print("buyPropertyAutomatically invoked by Player: \(player.id),", terminator: " ")
//        if let index = cities.firstIndex(where: {$0.tileId == player.tilePositionId}) {
//            print("in city: \(cities[index].id)", terminator: " ")
//
//            // always bought if sufficient player money && city unowned
//            if cities[index].currentLevel == 0 {
//                if player.money >= cities[index].cost && cities[index].ownerId == -1 { //sufficient player money && city unowned
//                    cities[index].ownerId = player.id
//                    player.tilePropertyIds.append(cities[index].tileId)
//                    cities[index].totalCost += cities[index].cost
//                    player.money -= cities[index].cost
//                    cities[index].currentLevel = 1
//                    print("bought", terminator: " ")
//                }
//            }
//
//            // always upgrade twice from 1 to level 3 if sufficient player money && city owned
//            if cities[index].currentLevel <= 2 && cities[index].currentLevel > 0  {
//                for _ in 1...2 {
//                    if player.money * 8/10 >= cities[index].cost && cities[index].ownerId == player.id { //sufficient player money && city owned
//                        cities[index].totalCost += cities[index].cost
//                        player.money -= cities[index].cost
//                        cities[index].currentLevel += 1
//                        print("upgraded", terminator: " ")
//                    }
//                }
//            }
//
//            // from level 3 onward, only upgrade by 1 level if sufficient player money && city owned
//            else if cities[index].currentLevel <= 4 && cities[index].currentLevel > 2 {
//                if player.money * 9/10 >= cities[index].cost && cities[index].ownerId == player.id { //sufficient player money && city owned
//                    cities[index].totalCost += cities[index].cost
//                    player.money -= cities[index].cost
//                    cities[index].currentLevel += 1
//                    print("upgraded", terminator: " ")
//                }
//            }
//
//            else if cities[index].currentLevel == 5 { print("already max upgraded") }
//
//            else { print(", but failed to bought or upgrade ") }
//            print("")
//        }
//
//        else {  print("but can not find city") }
//    }
//
    // Sell Property owned by game player
    func sellBeach(beach: inout Beach, player: inout Player) -> Bool{
        print("sellBeach invoked by Player: \(player.id),", terminator: " ")
        if let index = beaches.firstIndex(where: {$0.tileId == player.tilePositionId}) {
            print("in city: \(beaches[index].id)", terminator: " ")
            if (player.tilePropertyIds.contains(beaches[index].tileId)){
                beaches[index].ownerId = -1
                player.tilePropertyIds = player.tilePropertyIds.filter{$0 != beaches[index].tileId}
                beach.currentLevel = 0
                player.money += beach.cost
                print("sold")
                return true
            }
            print("but failed")
            return false
        }
        print("but can not find city")
        return false
    }
    
   
    
}
