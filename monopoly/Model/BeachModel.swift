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
    
    // Buy Beach by game player
    func buyBeach (player: inout Player) {
        print("buyBeach invoked by Player: \(player.id)", terminator: " ")
        if let index = beaches.firstIndex(where: {$0.tileId == player.tilePositionId}) {
            print("in beach: \(beaches[index].id),", terminator: " ")
            
            if player.money >= beaches[index].cost && beaches[index].ownerId == -1 { //sufficient player money && beach unowned
                beaches[index].ownerId = player.id
                player.tilePropertyIds.append(beaches[index].tileId)
                player.money -= beaches[index].cost
                
                beaches[index].currentLevel = 0
                for tileId in player.tilePropertyIds {
                    for beach in beaches {
                        if tileId == beach.tileId {
                            beaches[index].currentLevel += 1
                        }
                    }
                }
                print("bought", terminator: " ")
            }
            else { print(", but failed to bought") }
            print("")
        }
        
        else { print("but can not find beach") }
    }
    

    // Sell Beach owned by game player
    func sellBeach(beach: inout Beach, player: inout Player) -> Bool{
        print("sellBeach invoked by Player: \(player.id),", terminator: " ")
        if let index = beaches.firstIndex(where: {$0.tileId == player.tilePositionId}) {
            print("in beach: \(beaches[index].id)", terminator: " ")
            if (player.tilePropertyIds.contains(beaches[index].tileId)){
                beaches[index].ownerId = -1
                player.tilePropertyIds = player.tilePropertyIds.filter{$0 != beaches[index].tileId}
                beach.currentLevel -= 1
                player.money += beach.cost
                print("sold")
                return true
            }
            print("but failed")
            return false
        }
        print("but can not find beach")
        return false
    }
    
   
    
}
