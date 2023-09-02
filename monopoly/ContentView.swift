//
//  ContentView.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 16/08/2023.
//

import SwiftUI

struct ContentView: View {
    
    var tiles:[TilePosition] = TilePositionModel().tiles
    
    @StateObject var cities:CityModel = CityModel()
    @StateObject var beaches:BeachModel = BeachModel()
    @StateObject var players:PlayerModel = PlayerModel()

    @State var dollar1: Bool = false
    @State var dollar2: Bool = false

    @State var dice1: Int = 1
    @State var dice2: Int = 1
    var totalDice: Int { dice1 + dice2 }

    @State var player1Tile = startingPosition
    @State var player2Tile = startingPosition
    @State var player3Tile = startingPosition
    @State var player4Tile = startingPosition

    @State var player1Turn = false
    @State var player2Turn = false
    @State var player3Turn = false
    @State var player4Turn = false
    
    var currentGamePlayerId : Int{
        if (player1Turn && !player2Turn && !player3Turn && !player4Turn ) {
            return 1
        }
        else if (player2Turn && !player1Turn && !player3Turn && !player4Turn ) {
            return 2
        }
        else if (player3Turn && !player2Turn && !player1Turn && !player4Turn ) {
            return 3
        }
        else if (player4Turn && !player2Turn && !player3Turn && !player1Turn ) {
            return 4
        }
        else {
            return -1
        }
    }
    var diceColor : String {
        return players.players[currentGamePlayerId-1].color.rawValue
    }
    
    @State var timeLeft: Double = 60.0
    @State var timer: Timer?
    
    @State var isTimerRunning = false
    @State var endTurnMessage = false
    @State var startTurnMessage = false
    @State var paidRentMessage = false
    
    @State var showTileDetailedInfo = false
    @State var selectedTileId: Int = -1
    @State var cityBuyingOption: Set<Int> = []
    @State var totalBuyingCost = 0
    
    var body: some View {
        ZStack {
            
            // Turn View
            ZStack {
                /// END TURN MESSAGE VIEW
                if endTurnMessage {
                    ZStack {
                        VStack {
                            Spacer()
                                .frame(height: 30)
                            
                            VStack (spacing: 0) {
                                Text("Do you want to end")
                                    .frame(width: 210, height: 20)
                                    .font(.system(size: 14, weight: .semibold, design: .monospaced))

                                Text("your turn here ?")
                                    .frame(width: 210, height: 20)
                                    .font(.system(size: 14, weight: .semibold, design: .monospaced))

                                HStack {
                                    Button {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            endTurnMessage = false
                                            startTurnMessage = false
                                        }
                                        stopPlayerTimer(playerId: 1)
                                    } label: {
                                        Text("Yes")
                                            .font(.system(size: 14, weight: .semibold, design: .monospaced))
                                    }
                                    
                                    Button {
                                        endTurnMessage = false
                                    } label: {
                                        Text("No")
                                            .font(.system(size: 14, weight: .semibold, design: .monospaced))
                                    }
                                }
                                .padding(.top, 8)
                            }
                            .frame(width: 210, height: 180)
                            .background(.white)
                            .zIndex(2)

                        }
                        .frame(width: 210, height: 210)
                    }
                }
                
                /// START TURN MESSAGE VIEW
                if startTurnMessage {
                    ZStack {
                        Color.gray.opacity(0.4)
                            .ignoresSafeArea()
                        ZStack {
                            if (tiles[players.players[0].tilePositionId].type == .city) {
                                VStack (spacing: 4){
                                    BuyingCityView(buyingMessage: $startTurnMessage, cityBuyingOption: $cityBuyingOption, totalBuyingCost: $totalBuyingCost, cities: cities, players: players)
                                        .padding(.vertical, 4)
                                }
                            }
                            else if (tiles[players.players[0].tilePositionId].type == .beach) {
                                VStack (spacing: 4){
                                    BuyingBeachView(buyingMessage: $startTurnMessage, totalBuyingCost: $totalBuyingCost, beaches: beaches, players: players)
                                        .padding(.vertical, 4)
                                }
                            }
                            
                            
                        }
                        .frame(width: 240, height: 240)
                        .background(.white)
//                        .offset(y:-180)
                    }
                    .zIndex(-1)
                }
                
                /// PAID RENT MESSAGE
                if paidRentMessage {
                    
                }
                
                /// TIME LEFT TEXT VIEW
                ZStack {
                    HStack {
                        Text("Time Left: \(String(format: "%.1f", timeLeft))")
                            .font(.system(size: 10.5, weight: .bold, design: .monospaced))
                    }
                    .frame(width: 110, height: 20)
                    .background(.tint.opacity(0.9))
                    .cornerRadius(3)
                    .offset(x: -45, y: -90)
                    .foregroundColor(.white)
                    //  .opacity(isTimerRunning ? 1 : 0)
                }
                
                /// END TURN BUTTON VIEW
                ZStack {
                    Button {
                        endTurnMessage = true
                    } label: {
                        Text("End Turn")
                    }
                    .frame(width: 60, height: 20)
                    .background(.tint.opacity(0.9))
                    .cornerRadius(4)
                    .font(.system(size: 10.5, weight: .bold, design: .default))
                    .foregroundColor(.white)
                }
                .offset(x: 70, y: -90)

            }
            .frame(width: 210, height: 210)
            .border(.black, width: 0.3)
            .offset(y: -180)

            VStack{
                Spacer().frame(height: 20)
                /// BOARD VIEW
                ZStack() {
    
                    /// PLAYER POSITION VIEW
                    ZStack {
                        Image(systemName: "pawprint.fill")
                            .offset(x: player1Tile.posX - 8, y: player1Tile.posY - 8)
                            .font(.system(size: 10))
                            .foregroundColor(Color(players.players[0].color.rawValue))
                            .onChange(of: player1Turn) { turn in
                                if turn  {
                                    turnPlayedByPLayer()
                                    
                                } else {
                                    /// player 2 - start turn
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0 + 1) {
                                        resetPlayerTimer(newTime: 4)
                                        startPlayerTimer(playerId: 2)
                                    }
                                    /// player 3 - start turn
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 4 + 2) {
                                        resetPlayerTimer(newTime: 4)
                                        startPlayerTimer(playerId: 3)
                                    }
                                    /// player 4 - start turn
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 8 + 3) {
                                        resetPlayerTimer(newTime: 4)
                                        startPlayerTimer(playerId: 4)
                                    }
                                }
                            }
                        
                        Image(systemName: "pawprint.fill")
                            .offset(x: player2Tile.posX + 8, y: player2Tile.posY - 8)
                            .font(.system(size: 10))
                            .foregroundColor(Color(players.players[1].color.rawValue))
                            .onChange(of: player2Turn) { turn in
                                turn ? turnPlayedByPLayer() : nil
                            }
                        
                        Image(systemName: "pawprint.fill")
                            .offset(x: player3Tile.posX + 8, y: player3Tile.posY + 8)
                            .font(.system(size: 10))
                            .foregroundColor(Color(players.players[2].color.rawValue))
                            .onChange(of: player3Turn) { turn in
                                turn ? turnPlayedByPLayer() : nil
                            }
                        Image(systemName: "pawprint.fill")
                            .offset(x: player4Tile.posX - 8, y: player4Tile.posY + 8)
                            .font(.system(size: 10))
                            .foregroundColor(Color(players.players[3].color.rawValue))
                            .onChange(of: player4Turn) { turn in
                                turn ? turnPlayedByPLayer() : nil
                            }
                    }

                    /// TILE VIEWS
                    ZStack {
                        BottomTileView(cities: cities, beaches: beaches, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                        
                        LeftTileView(cities: cities, beaches: beaches, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                        
                        TopTileView(cities: cities, beaches: beaches, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                        
                        RightTileView(cities: cities, beaches: beaches, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                    }
                }
                
                /// MIDDLE BANNER
                ZStack {
                    HStack() {
                        VStack {
                            /// PLAYER 1 VIEW
                            ZStack {
                                HStack {
                                    PlayerNameMoneyView(players: players, playerId: 0) /// PLAYER NAME AND MONEY VIEW

                                    ZStack {
                                        if player1Turn {
                                            Circle()
                                                .trim(from: 0, to: CGFloat(timeLeft/60))
                                                .stroke(Color(diceColor).opacity(0.6),  lineWidth: 3)
                                                .frame(width: 43)
                                                .rotationEffect(.degrees(-90))
                                                .shadow(color: Color(diceColor), radius: 2)
                                        }
        //                                Image ("")
        //                                    .resizable()
        //                                    .background(.red.opacity(0.4))
        //                                    .frame(width: 40, height: 40)
        //                                    .clipShape(Circle())
                                    }
                                    .frame(width: 45)

                                }
                                .frame(width: 130, height: 50)
                                .background(player1Turn ? .gray.opacity(0.2) :.blue.opacity(0.2))
                            .cornerRadius(4)
                            }

                            /// PLAYER 2 VIEW
                            ZStack {
                                HStack {
                                    PlayerNameMoneyView(players: players, playerId: 1) /// PLAYER NAME AND MONEY VIEW

                                    ZStack {
                                        if player2Turn {
                                            Circle()
                                                .trim(from: 0, to: CGFloat(timeLeft/4))
                                                .stroke(Color(diceColor).opacity(0.6),  lineWidth: 3)
                                                .frame(width: 43)
                                                .rotationEffect(.degrees(-90))
                                                .shadow(color: Color(diceColor), radius: 2)
                                        }
        //                                Image ("")
        //                                    .resizable()
        //                                    .background(.brown.opacity(0.4))
        //                                    .frame(width: 40, height: 40)
        //                                    .clipShape(Circle())
                                    }
                                    .frame(width: 45)

                                }
                                .frame(width: 130, height: 50)
                                .background(player2Turn ? .gray.opacity(0.2) :.blue.opacity(0.2))
                            .cornerRadius(4)
                            }
                            
                        }
                        .padding(.horizontal, 4)

                        /// BUTTON VIEW
                        ZStack {
                            Button  {
                                /// player 1 - start turn
                                resetPlayerTimer(newTime: 60)
                                startPlayerTimer(playerId: 1)
                                player1Turn = true
                            } label: {
                                Image("dice\(dice1)")
                                    .resizable()
                                    .frame(width: 45, height: 45)
                                    .cornerRadius(9)
                                Image("dice\(dice2)")
                                    .resizable()
                                    .frame(width: 45, height: 45)
                                    .cornerRadius(9)
                            }
                        }
                        
                        VStack {
                            /// PLAYER 3 VIEW
                            ZStack {
                                HStack {
                                    PlayerNameMoneyView(players: players, playerId: 2) /// PLAYER NAME AND MONEY VIEW

                                    ZStack {
                                        if player3Turn {
                                            Circle()
                                                .trim(from: 0, to: CGFloat(timeLeft/4))
                                                .stroke(Color(diceColor).opacity(0.6),  lineWidth: 3)
                                                .frame(width: 43)
                                                .rotationEffect(.degrees(-90))
                                                .shadow(color: Color(diceColor), radius: 2)
                                        }
        //                                Image ("")
        //                                    .resizable()
        //                                    .background(.green.opacity(0.4))
        //                                    .frame(width: 40, height: 40)
        //                                    .clipShape(Circle())
                                    }
                                    .frame(width: 45)

                                }
                                .frame(width: 130, height: 50)
                                .background(player3Turn ? .gray.opacity(0.2) :.blue.opacity(0.2))
                            .cornerRadius(4)
                            }
                            
                            /// PLAYER 4 VIEW
                            ZStack {
                                HStack {
                                    PlayerNameMoneyView(players: players, playerId: 3) /// PLAYER NAME AND MONEY VIEW

                                    ZStack {
                                        if player4Turn {
                                            Circle()
                                                .trim(from: 0, to: CGFloat(timeLeft/4))
                                                .stroke(Color(diceColor).opacity(0.6),  lineWidth: 3)
                                                .frame(width: 43)
                                                .rotationEffect(.degrees(-90))
                                                .shadow(color: Color(diceColor), radius: 2)
                                        }
        //                                Image ("")
        //                                    .resizable()
        //                                    .background(.purple.opacity(0.4))
        //                                    .frame(width: 40, height: 40)
        //                                    .clipShape(Circle())
                                    }
                                    .frame(width: 45)

                                }
                                .frame(width: 130, height: 50)
                                .background(player4Turn ? .gray.opacity(0.2) :.blue.opacity(0.2))
                            .cornerRadius(4)
                            }
                            
                        }
                        .padding(.horizontal, 4)
                        
                    }
                    .padding(.vertical, 4)
                }
                
                Spacer()
            }
        }
    }
    
    func moveForwardPlayer1(){
        var nextTileId:Int
        if player1Tile.id >= 35 {nextTileId = 0} else {nextTileId = player1Tile.id + 1}
        let nextTile:TilePosition = tiles[nextTileId]

        /// moving in bottom section
        if nextTileId >= 1 && nextTileId < 10 {
            let diffX = player1Tile.posX - nextTile.posX
            withAnimation(.linear(duration: 0.07)){
                player1Tile.posX -= diffX*1/4
                player1Tile.posY -= 20*2/3
            }
            withAnimation(Animation.linear(duration: 0.1).delay(0.07)){
                player1Tile.posX -= diffX*1/4
                player1Tile.posY -= 20*1/3
            }
            withAnimation(Animation.linear(duration: 0.06).delay(0.17)){
                player1Tile.posX -= diffX*1/4
                player1Tile.posY += 20*1/3
            }
            withAnimation(Animation.linear(duration: 0.07).delay(0.23)){
                player1Tile = nextTile
                player1Tile.id = nextTileId
            }
        }
        /// moving in left section
        if nextTileId >= 10 && nextTileId < 10+9 {
            let diffY = player1Tile.posY - nextTile.posY
            
            withAnimation(.linear(duration: 0.07)){
                player1Tile.posX += 20*2/3
                player1Tile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.1).delay(0.07)){
                player1Tile.posX += 20*1/3
                player1Tile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.06).delay(0.17)){
                player1Tile.posX -= 20*1/3
                player1Tile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.07).delay(0.23)){
                player1Tile = nextTile
                player1Tile.id = nextTileId
            }
        }
        /// moving in top section
        if nextTileId >= 10+9 && nextTileId < 10+9+9 {
            let diffX = player1Tile.posX - nextTile.posX
            withAnimation(.linear(duration: 0.07)){
                player1Tile.posX -= diffX*1/4
                player1Tile.posY += 20*2/3
            }
            withAnimation(Animation.linear(duration: 0.1).delay(0.07)){
                player1Tile.posX -= diffX*1/4
                player1Tile.posY += 20*1/3
            }
            withAnimation(Animation.linear(duration: 0.06).delay(0.17)){
                player1Tile.posX -= diffX*1/4
                player1Tile.posY -= 20*1/3
            }
            withAnimation(Animation.linear(duration: 0.07).delay(0.23)){
                player1Tile = nextTile
                player1Tile.id = nextTileId
            }
        }
        /// moving in left section
        if nextTileId >= 10+9+9 && nextTileId < 10+9+9+9 || nextTileId == 0 {
            let diffY = player1Tile.posY - nextTile.posY
            
            withAnimation(.linear(duration: 0.07)){
                player1Tile.posX -= 20*2/3
                player1Tile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.1).delay(0.07)){
                player1Tile.posX -= 20*1/3
                player1Tile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.06).delay(0.17)){
                player1Tile.posX += 20*1/3
                player1Tile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.07).delay(0.23)){
                player1Tile = nextTile
                player1Tile.id = nextTileId
            }
        }
    
    }
    
    func moveForwardPlayer2(){
        var nextTileId:Int
        if player2Tile.id >= 35 {nextTileId = 0} else {nextTileId = player2Tile.id + 1}
        let nextTile:TilePosition = tiles[nextTileId]

        /// moving in bottom section
        if nextTileId >= 1 && nextTileId < 10 {
            let diffX = player2Tile.posX - nextTile.posX
            withAnimation(.linear(duration: 0.07)){
                player2Tile.posX -= diffX*1/4
                player2Tile.posY -= 20*2/3
            }
            withAnimation(Animation.linear(duration: 0.1).delay(0.07)){
                player2Tile.posX -= diffX*1/4
                player2Tile.posY -= 20*1/3
            }
            withAnimation(Animation.linear(duration: 0.06).delay(0.17)){
                player2Tile.posX -= diffX*1/4
                player2Tile.posY += 20*1/3
            }
            withAnimation(Animation.linear(duration: 0.07).delay(0.23)){
                player2Tile = nextTile
                player2Tile.id = nextTileId
            }
        }
        /// moving in left section
        if nextTileId >= 10 && nextTileId < 10+9 {
            let diffY = player2Tile.posY - nextTile.posY
            
            withAnimation(.linear(duration: 0.07)){
                player2Tile.posX += 20*2/3
                player2Tile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.1).delay(0.07)){
                player2Tile.posX += 20*1/3
                player2Tile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.06).delay(0.17)){
                player2Tile.posX -= 20*1/3
                player2Tile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.07).delay(0.23)){
                player2Tile = nextTile
                player2Tile.id = nextTileId
            }
        }
        /// moving in top section
        if nextTileId >= 10+9 && nextTileId < 10+9+9 {
            let diffX = player2Tile.posX - nextTile.posX
            withAnimation(.linear(duration: 0.07)){
                player2Tile.posX -= diffX*1/4
                player2Tile.posY += 20*2/3
            }
            withAnimation(Animation.linear(duration: 0.1).delay(0.07)){
                player2Tile.posX -= diffX*1/4
                player2Tile.posY += 20*1/3
            }
            withAnimation(Animation.linear(duration: 0.06).delay(0.17)){
                player2Tile.posX -= diffX*1/4
                player2Tile.posY -= 20*1/3
            }
            withAnimation(Animation.linear(duration: 0.07).delay(0.23)){
                player2Tile = nextTile
                player2Tile.id = nextTileId
            }
        }
        /// moving in left section
        if nextTileId >= 10+9+9 && nextTileId < 10+9+9+9 || nextTileId == 0 {
            let diffY = player2Tile.posY - nextTile.posY
            
            withAnimation(.linear(duration: 0.07)){
                player2Tile.posX -= 20*2/3
                player2Tile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.1).delay(0.07)){
                player2Tile.posX -= 20*1/3
                player2Tile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.06).delay(0.17)){
                player2Tile.posX += 20*1/3
                player2Tile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.07).delay(0.23)){
                player2Tile = nextTile
                player2Tile.id = nextTileId
            }
        }
    
    }

    func moveForwardPlayer3(){
        var nextTileId:Int
        if player3Tile.id >= 35 {nextTileId = 0} else {nextTileId = player3Tile.id + 1}
        let nextTile:TilePosition = tiles[nextTileId]

        /// moving in bottom section
        if nextTileId >= 1 && nextTileId < 10 {
            let diffX = player3Tile.posX - nextTile.posX
            withAnimation(.linear(duration: 0.07)){
                player3Tile.posX -= diffX*1/4
                player3Tile.posY -= 20*2/3
            }
            withAnimation(Animation.linear(duration: 0.1).delay(0.07)){
                player3Tile.posX -= diffX*1/4
                player3Tile.posY -= 20*1/3
            }
            withAnimation(Animation.linear(duration: 0.06).delay(0.17)){
                player3Tile.posX -= diffX*1/4
                player3Tile.posY += 20*1/3
            }
            withAnimation(Animation.linear(duration: 0.07).delay(0.23)){
                player3Tile = nextTile
                player3Tile.id = nextTileId
            }
        }
        /// moving in left section
        if nextTileId >= 10 && nextTileId < 10+9 {
            let diffY = player3Tile.posY - nextTile.posY
            
            withAnimation(.linear(duration: 0.07)){
                player3Tile.posX += 20*2/3
                player3Tile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.1).delay(0.07)){
                player3Tile.posX += 20*1/3
                player3Tile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.06).delay(0.17)){
                player3Tile.posX -= 20*1/3
                player3Tile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.07).delay(0.23)){
                player3Tile = nextTile
                player3Tile.id = nextTileId
            }
        }
        /// moving in top section
        if nextTileId >= 10+9 && nextTileId < 10+9+9 {
            let diffX = player3Tile.posX - nextTile.posX
            withAnimation(.linear(duration: 0.07)){
                player3Tile.posX -= diffX*1/4
                player3Tile.posY += 20*2/3
            }
            withAnimation(Animation.linear(duration: 0.1).delay(0.07)){
                player3Tile.posX -= diffX*1/4
                player3Tile.posY += 20*1/3
            }
            withAnimation(Animation.linear(duration: 0.06).delay(0.17)){
                player3Tile.posX -= diffX*1/4
                player3Tile.posY -= 20*1/3
            }
            withAnimation(Animation.linear(duration: 0.07).delay(0.23)){
                player3Tile = nextTile
                player3Tile.id = nextTileId
            }
        }
        /// moving in left section
        if nextTileId >= 10+9+9 && nextTileId < 10+9+9+9 || nextTileId == 0 {
            let diffY = player3Tile.posY - nextTile.posY
            
            withAnimation(.linear(duration: 0.07)){
                player3Tile.posX -= 20*2/3
                player3Tile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.1).delay(0.07)){
                player3Tile.posX -= 20*1/3
                player3Tile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.06).delay(0.17)){
                player3Tile.posX += 20*1/3
                player3Tile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.07).delay(0.23)){
                player3Tile = nextTile
                player3Tile.id = nextTileId
            }
        }
    
    }

    func moveForwardPlayer4(){
        var nextTileId:Int
        if player4Tile.id >= 35 {nextTileId = 0} else {nextTileId = player4Tile.id + 1}
        let nextTile:TilePosition = tiles[nextTileId]

        /// moving in bottom section
        if nextTileId >= 1 && nextTileId < 10 {
            let diffX = player4Tile.posX - nextTile.posX
            withAnimation(.linear(duration: 0.07)){
                player4Tile.posX -= diffX*1/4
                player4Tile.posY -= 20*2/3
            }
            withAnimation(Animation.linear(duration: 0.1).delay(0.07)){
                player4Tile.posX -= diffX*1/4
                player4Tile.posY -= 20*1/3
            }
            withAnimation(Animation.linear(duration: 0.06).delay(0.17)){
                player4Tile.posX -= diffX*1/4
                player4Tile.posY += 20*1/3
            }
            withAnimation(Animation.linear(duration: 0.07).delay(0.23)){
                player4Tile = nextTile
                player4Tile.id = nextTileId
            }
        }
        /// moving in left section
        if nextTileId >= 10 && nextTileId < 10+9 {
            let diffY = player4Tile.posY - nextTile.posY
            
            withAnimation(.linear(duration: 0.07)){
                player4Tile.posX += 20*2/3
                player4Tile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.1).delay(0.07)){
                player4Tile.posX += 20*1/3
                player4Tile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.06).delay(0.17)){
                player4Tile.posX -= 20*1/3
                player4Tile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.07).delay(0.23)){
                player4Tile = nextTile
                player4Tile.id = nextTileId
            }
        }
        /// moving in top section
        if nextTileId >= 10+9 && nextTileId < 10+9+9 {
            let diffX = player4Tile.posX - nextTile.posX
            withAnimation(.linear(duration: 0.07)){
                player4Tile.posX -= diffX*1/4
                player4Tile.posY += 20*2/3
            }
            withAnimation(Animation.linear(duration: 0.1).delay(0.07)){
                player4Tile.posX -= diffX*1/4
                player4Tile.posY += 20*1/3
            }
            withAnimation(Animation.linear(duration: 0.06).delay(0.17)){
                player4Tile.posX -= diffX*1/4
                player4Tile.posY -= 20*1/3
            }
            withAnimation(Animation.linear(duration: 0.07).delay(0.23)){
                player4Tile = nextTile
                player4Tile.id = nextTileId
            }
        }
        /// moving in left section
        if nextTileId >= 10+9+9 && nextTileId < 10+9+9+9 || nextTileId == 0 {
            let diffY = player4Tile.posY - nextTile.posY
            
            withAnimation(.linear(duration: 0.07)){
                player4Tile.posX -= 20*2/3
                player4Tile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.1).delay(0.07)){
                player4Tile.posX -= 20*1/3
                player4Tile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.06).delay(0.17)){
                player4Tile.posX += 20*1/3
                player4Tile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.07).delay(0.23)){
                player4Tile = nextTile
                player4Tile.id = nextTileId
            }
        }
    
    }
    
    func diceRoll(num: Int) -> Int{
        var ran = Int.random(in: 1...6)
        while ran == num {
            ran = Int.random(in: 1...6)
        }
        return ran
    }
    
    /// UI Animation for all game player movement
    func moveForwardBySteps(steps: Int, player: inout Player){
        print("moveForwardBySteps() invoked,", terminator: " ")
        switch player.id {
            case 1:
                print("Player 1, ", terminator: "")
                var delayMove: Double = 0
                for _ in 0..<steps {
                    delayMove += 0.3
                    DispatchQueue.main.asyncAfter(deadline: .now() + delayMove) {
                        moveForwardPlayer1()
                    }
                }
            case 2:
                print("Player 2, ", terminator: "")
                var delayMove: Double = 0
                for _ in 0..<steps {
                    delayMove += 0.3
                    DispatchQueue.main.asyncAfter(deadline: .now() + delayMove) {
                        moveForwardPlayer2()
                    }
                }
            case 3:
                print("Player 3, ", terminator: "")
                var delayMove: Double = 0
                for _ in 0..<steps {
                    delayMove += 0.3
                    DispatchQueue.main.asyncAfter(deadline: .now() + delayMove) {
                        moveForwardPlayer3()
                    }
                }
            case 4:
                print("Player 4, ", terminator: "")
                var delayMove: Double = 0
                for _ in 0..<steps {
                    delayMove += 0.3
                    DispatchQueue.main.asyncAfter(deadline: .now() + delayMove) {
                        moveForwardPlayer4()
                    }
                }
            default:
                print("No Player selected")
        }
        
        let targetTileId = (player.tilePositionId + steps) % 36
        player.setPosXY(x: tiles[targetTileId].posX, y: tiles[targetTileId].posY)
        player.updateTilePositionId()
        player.printPlayerBasicInfo()
    }
        
    func startPlayerTimer(playerId: Int) {
        if timer == nil {
            isTimerRunning = true
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){ _ in
                if timeLeft > 0 {
                    timeLeft -= 0.1
                } else {
                    stopPlayerTimer(playerId: playerId)
                    
                }
            }
        }
    }
    
    func resetPlayerTimer(newTime: Double) {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
        timeLeft = newTime
    }
    
    func stopPlayerTimer(playerId: Int) {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
        switch playerId {
            case 1:
                player1Turn =  false
                player2Turn =  true
            case 2:
                player2Turn =  false
                player3Turn =  true
            case 3:
                player3Turn =  false
                player4Turn =  true
            case 4:
                player4Turn =  false
            default:
                break
        }
    }
        
    func pLayerCityTileAction(playerId: Int) {
        print("playerCityTileAction invoked() by Player \(playerId),", terminator: " ")
        cities.updateCityBuyingOption(player: players.players[playerId-1], options: &cityBuyingOption)
        
        if let index = cities.cities.firstIndex(where: {$0.tileId == players.players[playerId-1].tilePositionId}) {
            print("in city: \(cities.cities[index].id)", terminator: " ")
            if cities.cities[index].ownerId != -1 && cities.cities[index].ownerId != playerId {
                players.players[playerId-1].money -= cities.cities[index].rent
                players.players[cities.cities[index].ownerId-1].money += cities.cities[index].rent
                paidRentMessage = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    paidRentMessage = false
                }

                print("Player \(playerId) paid \(cities.cities[index].rent) to Player  \(players.players[cities.cities[index].ownerId-1].id)")
            }
            else {
                cities.cities[index].printCityBasicInfo()
                if playerId == 1 {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        startTurnMessage = true
                    }
                }
                else {
                    startTurnMessage = false
                    cities.buyCityAutomatically(player: &players.players[playerId-1])
                }
            }
        }
        else {
            print("but can not find city")
        }
        print("")
    }
    
    func pLayerBeachTileAction(playerId: Int) {
        print("pLayerBeachTileAction invoked() by Player \(playerId),", terminator: " ")
        
        if let index = beaches.beaches.firstIndex(where: {$0.tileId == players.players[playerId-1].tilePositionId}) {
            print("in beach: \(beaches.beaches[index].id)", terminator: " ")
            
            if beaches.beaches[index].ownerId != -1 && beaches.beaches[index].ownerId != playerId {
                players.players[playerId-1].money -= beaches.beaches[index].rent
                players.players[beaches.beaches[index].ownerId-1].money += beaches.beaches[index].rent
                paidRentMessage = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    paidRentMessage = false
                }
                
                print("Player \(playerId) paid \(beaches.beaches[index].rent) to Player  \(players.players[beaches.beaches[index].ownerId-1].id)")
            }
            else {
                beaches.beaches[index].printBeachBasicInfo()
                if playerId == 1 {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        startTurnMessage = true
                    }
                }
                else {
                    startTurnMessage = false
                    beaches.buyBeach(player: &players.players[playerId-1])
                }
            }
        }
        else {
            print("but can not find beach")
        }
        print("")
    }
    
    func pLayerTaxTileAction(playerId: Int) {
        print("pLayerTaxTileAction invoked() by Player \(playerId),", terminator: " ")
        let tax = Int.random(in: 5...15)
        print("Player \(playerId) paid \(players.players[playerId-1].money*tax/100) as Tax")
        players.players[playerId-1].money -= players.players[playerId-1].money*tax/100
    }
    
    func pLayerMoneyTileAction(playerId: Int) {
        print("pLayerTaxTileAction invoked() by Player \(playerId),", terminator: " ")
        let money = Int.random(in: 100...150)
        print("Player \(playerId) received \(money) as Free Reward")
        players.players[playerId-1].money += money
    }

    func turnPlayedByPLayer() {
        var delayRoll:Double = 0
        for _ in 0..<15 {
            withAnimation(.easeIn(duration: 0.08).delay(delayRoll)){
                dice1 = diceRoll(num: dice1)
                dice2 = diceRoll(num: dice2)
                delayRoll += 0.08
            }
        }
        
        print("\nplayer \(currentGamePlayerId) roll: \(totalDice)", terminator: ", ")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            moveForwardBySteps(steps: totalDice, player: &players.players[currentGamePlayerId-1])
            if (tiles[players.players[currentGamePlayerId-1].tilePositionId].type == .city) {
                pLayerCityTileAction(playerId: currentGamePlayerId)
            }
            else if (tiles[players.players[currentGamePlayerId-1].tilePositionId].type == .beach) {
                pLayerBeachTileAction(playerId: currentGamePlayerId)
            }
            else if (tiles[players.players[currentGamePlayerId-1].tilePositionId].type == .tax) {
                pLayerTaxTileAction(playerId: currentGamePlayerId)
            }
            else if (tiles[players.players[currentGamePlayerId-1].tilePositionId].type == .money) {
                pLayerMoneyTileAction(playerId: currentGamePlayerId)
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
