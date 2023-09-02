//
//  City.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 23/08/2023.
//

import Foundation


/// Defines Tile City struct
struct City: Codable, Hashable, Identifiable, Equatable{
    var id: Int
    var tileId: Int
    var ownerId: Int
    var cityName: String
    var currentLevel: Int // 0, 1, 2, 3, 4, 5
    let rentByLevel: [Int]
    let costByLevel: [Int]

    var rent: Int {
        rentByLevel[currentLevel]
    }
    var cost: Int {
        costByLevel[currentLevel]
    }
    var totalCost: Int = 0
    
    func printCityBasicInfo () {
        print("City id \(id), tileId: \(tileId), ownerId: \(ownerId), level: \(currentLevel), rent: \(rent)")
    }
}


//let testCity = TilePosition(id: 1, posX: 105, posY: 150, type: .city)

