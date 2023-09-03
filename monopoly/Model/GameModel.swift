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
        game = Game(id: 1, players: PlayerModel().players, cities: CityModel().cities, beaches: BeachModel().beaches, turn: 0)
    }
    
    
}
