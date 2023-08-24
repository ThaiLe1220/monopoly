//
//  Position.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 17/08/2023.
//

import Foundation


/// Defines Tile Position struct
struct TilePosition:Codable, Hashable, Identifiable, Equatable{
    var id: Int
    var posX: CGFloat
    var posY: CGFloat
    var type: TileType
    
    enum TileType: String, Codable, CaseIterable {
        case city = "city"
        case beach = "beach"
        case chance = "chance"
        case money = "money"
        case tax = "tax"
        case island = "island"
        case tour = "tour"
        case champion = "champion"
        case start = "start"
        case empty = ""
    }
    
}


let startingPosition = TilePosition(id: 0, posX: 150, posY: 150, type: .start)
let testTilePosition1 = TilePosition(id: 1, posX: 105, posY: 150, type: .city)
let testTilePosition2 = TilePosition(id: 2, posX: 75, posY: 150, type: .city)
let testTilePosition3 = TilePosition(id: 3, posX: 45, posY: 150, type: .city)
let testTilePosition4 = TilePosition(id: 4, posX: 15, posY: 150, type: .tax)
