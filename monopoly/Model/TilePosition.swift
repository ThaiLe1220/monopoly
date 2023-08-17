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
    var angle: Double
}


let testTilePosition = TilePosition(id: 0, posX: 150, posY: 150, angle: 0)
