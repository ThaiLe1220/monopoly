//
//  Game.swift
//  monopoly
//
//  Created by Trang Le on 03/09/2023.
//

import Foundation

/// Defines Game struct
struct Game: Codable, Equatable, Identifiable {
    var id: Int
    var username: String
    var startingMoney: Int
    var language: String
    var darkModeEnabled: Bool // You can name this whatever you prefer
    var turn: Int
    var players: [Player]
    var cities: [City]
    var beaches: [Beach]
    var achievements: [Achievement]
    var adjusted: Bool
    var difficulty = 0
    var score = 0
}


//let emptyGame = Game(id: 1, players: [], turn: 0)
let defaultGame = Game(id: -1, username: "", startingMoney: 1000, language: "en", darkModeEnabled: false, turn: 0, players: PlayerModel().players, cities: CityModel().cities, beaches: BeachModel().beaches, achievements: AchievementModel().achievements, adjusted: false, difficulty: 0, score: 0)
