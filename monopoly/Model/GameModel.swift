//
//  GameModel.swift
//  monopoly
//
//  Created by Trang Le on 03/09/2023.
//

import Foundation

class GameModel: ObservableObject {
    @Published var games: [Game]
    @Published var game: Game
    var lastId: Int {
        var max = 0
        for game in games {
            if game.id > max {
                max = game.id
            }
        }
        return max
    }
    
    init () {
        game = defaultGame
        
        games = []
    }
    
    func addGame (game: Game) {
        print("addGame evoked")
        var newGame = game
        newGame.id = lastId+1
        games.append(newGame)
    }
    
    func deleteGame (game: Game) {
        print("deleteGame evoked")
        for g in games {
            if g.id == game.id {
                games.remove(at: g.id)
            }
        }
    }
    
}
