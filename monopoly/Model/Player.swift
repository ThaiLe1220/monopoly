//
//  Player.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 18/08/2023.
//

import Foundation

/// Defines Player struct
struct Player:Codable, Hashable, Identifiable, Equatable{
    var id: Int
    var name: String
    var posX: CGFloat
    var posY: CGFloat
    var tilePositionId : Int
    var tilePropertyIds: [Int]
    var color: Color

    var money: Int

    enum Color: String, Codable, CaseIterable {
        case player0 = "Player0"
        case player1 = "Player1"
        case player2 = "Player2"
        case player3 = "Player3"
        case player4 = "Player4"
    }
    
    mutating func updateTilePositionId () {
        if let currentTile = TilePositionModel().tiles.first(where: {$0.posX == posX && $0.posY == posY}) {
            tilePositionId = currentTile.id
        } else {
            tilePositionId = -1
        }
    }

    mutating func setPosXY (x: CGFloat, y: CGFloat) {
        posX = x
        posY = y
    }

    func printPlayerBasicInfo () {
        print("id \(id), x: \(posX), y: \(posY), tile: \(tilePositionId)")
    }
    
    func printPlayerAllInfo () {
        print("id \(id), x: \(posX), y: \(posY), tile: \(tilePositionId), own: \(tilePropertyIds), money: \(money)")
    }
}

var testPlayer = Player(id: 0, name: "Eugene", posX: 150, posY: 150, tilePositionId: 0, tilePropertyIds: [1, 2], color: .player0, money: 2000)

var player1 = Player(id: 1, name: "Eugene", posX: 150, posY: 150, tilePositionId: 0, tilePropertyIds: [], color: .player1, money: 1000)
var player2 = Player(id: 2, name: "Hera", posX: 150, posY: 150, tilePositionId: 0, tilePropertyIds: [], color: .player2, money: 100)
var player3 = Player(id: 3, name: "Peterson", posX: 150, posY: 150, tilePositionId: 0, tilePropertyIds: [], color: .player3, money: 100)
var player4 = Player(id: 4, name: "Robert", posX: 150, posY: 150, tilePositionId: 0, tilePropertyIds: [], color: .player4, money: 100)

var testPlayers = [player1, player2, player3, player4]
