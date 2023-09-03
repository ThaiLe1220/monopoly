//
//  Game.swift
//  monopoly
//
//  Created by Trang Le on 03/09/2023.
//

import Foundation

/// Defines Game struct
struct Game: Codable, Hashable, Identifiable, Equatable{
    var id: Int
    var players: [Player]
    var cities: [City]
    var beaches: [Beach]
    var turn: Int


}


//let emptyGame = Game(id: 1, players: [], turn: 0)

