//
//  PlayerModel.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 20/08/2023.
//

import Foundation

class PlayerModel: ObservableObject {
    @Published var players: [Player] = []

    init () {
        players = [player1, player2, player3, player4]
    }
    
    
}

