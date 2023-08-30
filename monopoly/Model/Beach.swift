//
//  Beach.swift
//  monopoly
//
//  Created by Thai, Le Hong on 30/08/2023.
//

import Foundation

/// Defines Tile Beach struct
struct Beach: Codable, Hashable, Identifiable, Equatable{
    var id: Int
    var tileId: Int
    var ownerId: Int
    var beachName: String
    var currentLevel: Int // 0, 1, 2, 3, 4
    let rent: [Int]
    let cost: Int

   
    func printBeachBasicInfo () {
        print("id \(id), tileId: \(tileId), ownerId: \(ownerId), level: \(currentLevel), rent: \(rent)")
    }
}


//let testBeach = TilePosition(id: 1, posX: 105, posY: 150, type: .city)

