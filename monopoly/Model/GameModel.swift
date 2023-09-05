//
//  GameModel.swift
//  monopoly
//
//  Created by Trang Le on 03/09/2023.
//

import Foundation

class GameModel: ObservableObject {
    @Published var game: Game
    
    init () {
        game = Game(username: "Eugene", startingMoney: 2000, language: "en", darkModeEnabled: false, turn: 0, players: PlayerModel().players, cities: CityModel().cities, beaches: BeachModel().beaches, achivements: AchievementModel().achievements, adjusted: false)
    }
    
    
}
