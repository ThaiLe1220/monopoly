//
//  Game.swift
//  monopoly
//
//  Created by Trang Le on 03/09/2023.
//

import Foundation

/// Defines Game struct
struct Game: Codable, Equatable {
    var username: String
    var startingMoney: Int
    var language: String
    var darkModeEnabled: Bool // You can name this whatever you prefer
    var turn: Int
    var players: [Player]
    var cities: [City]
    var beaches: [Beach]
    var achivements: [Achievement]
    var adjusted: Bool

}


//let emptyGame = Game(id: 1, players: [], turn: 0)

