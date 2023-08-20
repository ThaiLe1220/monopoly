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
    
//    mutating func updateByTilePositionId(inputId: Int) {
//        tilePositionId = inputId
//        po
//    }
    
    mutating func updateTilePositionId () {
        if let current = TilePositionModel().tiles.first(where: {$0.posX == posX && $0.posY == posY}) {
            tilePositionId = current.id
        } else {
            tilePositionId = -1
        }
    }

    mutating func setPosXY (x: CGFloat, y: CGFloat) {
        posX = x
        posY = y
    }

    func printBasicInfo () {
        print("id \(id), x: \(posX), y: \(posY), tile: \(tilePositionId)")
    }
    
    func printEveryInfo () {
        print("id \(id), x: \(posX), y: \(posY), tile: \(tilePositionId), own: \(tilePropertyIds), money: \(money)")
    }
}


var testPlayer = Player(id: 0, posX: 150, posY: 150, tilePositionId: 0, tilePropertyIds: [1, 2, 4], color: .player0, money: 10000)
var player1 = Player(id: 1, posX: 150, posY: 150, tilePositionId: 0, tilePropertyIds: [1, 2, 4], color: .player1, money: 10000)
var player2 = Player(id: 2, posX: 150, posY: 150, tilePositionId: 0, tilePropertyIds: [10, 11, 17], color: .player2, money: 10000)
var player3 = Player(id: 3, posX: 150, posY: 150, tilePositionId: 0, tilePropertyIds: [19, 25, 26], color: .player3, money: 10000)
var player4 = Player(id: 4, posX: 150, posY: 150, tilePositionId: 0, tilePropertyIds: [28, 33, 35], color: .player4, money: 10000)

var testPlayers = [player1, player2, player3, player4]
