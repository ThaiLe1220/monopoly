//
//  ContentView.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 16/08/2023.
//

import SwiftUI

struct ContentView: View {
    
    var tiles:[TilePosition] = TilePositionModel().tiles
    @State var dollar1: Bool = false
    @State var dollar2: Bool = false

    @State var dice1: Int = 1
    @State var dice2: Int = 1
    var totalDice: Int { dice1 + dice2 }
    
    @State var gamePlayer1: Player = player1
    @State var gamePlayer2: Player = player2
    @State var gamePlayer3: Player = player3
    @State var gamePlayer4: Player = player4

    @State var player1Tile = startingPosition
    @State var player2Tile = startingPosition
    @State var player3Tile = startingPosition
    @State var player4Tile = startingPosition

    @State var player1Turn = false
    @State var player2Turn = false
    @State var player3Turn = false
    @State var player4Turn = false
    
    @State var timeLeft: Double = 10.0
    @State var timer: Timer?
    @State var isTimerRunning = false
    @State var popupMessage = false

    var diceColor : String {
        if player4Turn {return player4.color.rawValue}
        if player3Turn {return player3.color.rawValue}
        if player2Turn {return player2.color.rawValue}
        return player1.color.rawValue
    }
    
    var body: some View {
        ZStack {
            /// POPUP MESSAGE VIEW
            if popupMessage {
                ZStack {
                    Color.gray.opacity(0.4)
                        .ignoresSafeArea()
                    VStack {
                        Text("Do you want to end your turn here")
                        HStack {
                            Button {
                                popupMessage = false
                                stopPlayerTimer(playerId: 1)
                            } label: {
                                Text("Yes")
                            }

                            Button {
                                popupMessage = false
                            } label: {
                                Text("No")
                            }
                        }
                    }
                    .frame(width: 240, height: 80)
                    .background(.white)
                    .font(.system(size: 14))
                    .offset(y:-100)
                }
            }
    
            VStack{
                Spacer().frame(height: 20)
                /// BOARD VIEW
                ZStack() {
                    
                    /// TIME LEFT VIEW
                    ZStack {
                        HStack {
                            Text("Time Left: \(String(format: "%.1f", timeLeft))")
                                .font(.system(size: 10, weight: .regular, design: .monospaced))
                        }
                        .frame(width: 100, height: 20)
                        .border(.black, width: 0.3)
                        .offset(x: -120 + 50, y: -120 + 10)
//                        .opacity(isTimerRunning ? 1 : 0)
                    }
                
                    /// END TURN VIEW
                    ZStack {
                        Button {
                            popupMessage = true
                        } label: {
                            Text("End Turn")
                        }
                        .frame(width: 60, height: 20)
                        .border(.black, width: 0.3)
                        .foregroundColor(.black)
                        .font(.system(size: 10, weight: .regular, design: .monospaced))
                        .offset(x: 120 - 30, y: -120 + 10)
                    }

                    /// DOLLARS ANIMATION
    //                ZStack {
    //                    Image(systemName: "dollarsign")
    //                        .font(.title2)
    //                        .foregroundColor(.green)
    //                        .offset(x: -60)
    //                        .rotationEffect(.degrees(dollar1 ? 360: 0))
    //                        .animation(.linear(duration: 6).delay(0.0).repeatForever(autoreverses: .random()), value: dollar1)
    //                        .onAppear(){
    //                            dollar1.toggle()
    //                        }
    //
    //                    Image(systemName: "dollarsign")
    //                        .font(.title2)
    //                        .foregroundColor(.green)
    //                        .offset(x: 60)
    //                        .rotationEffect(.degrees(dollar2 ? 360: 0))
    //                        .animation(.linear(duration: 5).delay(0.0).repeatForever(autoreverses: .random()), value: dollar2)
    //                        .onAppear(){
    //                            dollar2.toggle()
    //                        }
    //                }
                    
                    /// PLAYER POSITION VIEW
                    ZStack {
                        Image(systemName: "pawprint.fill")
                            .offset(x: player1Tile.posX - 8, y: player1Tile.posY - 8)
                            .font(.system(size: 12))
                            .foregroundColor(Color(gamePlayer1.color.rawValue))
                            .onChange(of: player1Turn) { turn in
                                if turn  {
                                    turnPlayedByPLayer()
                                } else {
                                    /// player 2 - start turn
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0 + 1) {
                                        resetPlayerTimer(playerId: 2, newTime: 4)
                                        startPlayerTimer(playerId: 2)
                                    }
                                    /// player 3 - start turn
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 4 + 2) {
                                        resetPlayerTimer(playerId: 3, newTime: 4)
                                        startPlayerTimer(playerId: 3)
                                    }
                                    /// player 4 - start turn
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 8 + 3) {
                                        resetPlayerTimer(playerId: 4, newTime: 4)
                                        startPlayerTimer(playerId: 4)
                                    }
                                }
                            }
                        
                        Image(systemName: "pawprint.fill")
                            .offset(x: player2Tile.posX + 8, y: player2Tile.posY - 8)
                            .font(.system(size: 12))
                            .foregroundColor(Color(gamePlayer2.color.rawValue))
                            .onChange(of: player2Turn) { turn in
                                turn ? turnPlayedByPLayer() : nil
                            }
                        
                        Image(systemName: "pawprint.fill")
                            .offset(x: player3Tile.posX + 8, y: player3Tile.posY + 8)
                            .font(.system(size: 13))
                            .foregroundColor(Color(gamePlayer3.color.rawValue))
                            .onChange(of: player3Turn) { turn in
                                turn ? turnPlayedByPLayer() : nil
                            }
                        Image(systemName: "pawprint.fill")
                            .offset(x: player4Tile.posX - 8, y: player4Tile.posY + 8)
                            .font(.system(size: 12))
                            .foregroundColor(Color(gamePlayer4.color.rawValue))
                            .onChange(of: player4Turn) { turn in
                                turn ? turnPlayedByPLayer() : nil
                            }
                    }

                    /// TILE VIEWS
                    ZStack {
                        BottomTileView()
                        LeftTileView()
                        TopTileView()
                        RightTileView()
                    }
                }
                
                /// MIDDLE BANNER
                HStack() {
                    VStack {
                        /// PLAYER 1 VIEW
                        HStack {
                            PlayerNameMoneyView(player: $gamePlayer1) /// PLAYER NAME AND MONEY VIEW

                            ZStack {
                                if player1Turn {
                                    Circle()
                                        .trim(from: 0, to: CGFloat(timeLeft/10))
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

                        
                        /// PLAYER 2 VIEW
                        HStack {
                            PlayerNameMoneyView(player: $gamePlayer2) /// PLAYER NAME AND MONEY VIEW

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
                    .padding(.horizontal, 4)

                    /// BUTTON VIEW
                    ZStack {
                        Button  {
                            /// player 1 - start turn
                            resetPlayerTimer(playerId: 1, newTime: 10)
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
                        HStack {
                            PlayerNameMoneyView(player: $gamePlayer3) /// PLAYER NAME AND MONEY VIEW

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
                        
                        /// PLAYER 4 VIEW
                        HStack {
                            PlayerNameMoneyView(player: $gamePlayer4) /// PLAYER NAME AND MONEY VIEW
                            
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
                    .padding(.horizontal, 4)

                    
                }
                .padding(.vertical, 4)
                
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
    
    func moveForwardBySteps(steps: Int, player: inout Player){
        print("moveForwardBySteps() invoked/ ", terminator: "")
        switch player.id {
            case 1:
                print("Player 1/ ", terminator: "")
                var delayMove: Double = 0
                for _ in 0..<steps {
                    delayMove += 0.3
                    DispatchQueue.main.asyncAfter(deadline: .now() + delayMove) {
                        moveForwardPlayer1()
                    }
                }
                
            case 2:
                print("Player 2/ ", terminator: "")
                var delayMove: Double = 0
                for _ in 0..<steps {
                    delayMove += 0.3
                    DispatchQueue.main.asyncAfter(deadline: .now() + delayMove) {
                        moveForwardPlayer2()
                    }
                }
                
            case 3:
                print("Player 3/ ", terminator: "")
                var delayMove: Double = 0
                for _ in 0..<steps {
                    delayMove += 0.3
                    DispatchQueue.main.asyncAfter(deadline: .now() + delayMove) {
                        moveForwardPlayer3()
                    }
                }
                
            case 4:
                print("Player 4/ ", terminator: "")
                var delayMove: Double = 0
                for _ in 0..<steps {
                    delayMove += 0.3
                    DispatchQueue.main.asyncAfter(deadline: .now() + delayMove) {
                        moveForwardPlayer4()
                    }
                }
                
            default:
                print("[No Player selected]/")
        }
        
        let targetTileId = (player.tilePositionId + steps) % 36
        player.setPosXY(x: tiles[targetTileId].posX, y: tiles[targetTileId].posY)
        player.updateTilePositionId()
        player.printBasicInfo()
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
        
        let delayMove: Double = 1.2
        
        if (player1Turn) {
            print("player 1 roll: \(totalDice)", terminator: ", ")
            DispatchQueue.main.asyncAfter(deadline: .now() + delayMove) {
                moveForwardBySteps(steps: totalDice, player: &gamePlayer1)
            }
        }
        
        if (player2Turn) {
            print("player 2 roll: \(totalDice)", terminator: ", ")
            DispatchQueue.main.asyncAfter(deadline: .now() + delayMove) {
                moveForwardBySteps(steps: totalDice, player: &gamePlayer2)
            }
        }
        
        if (player3Turn) {
            print("player 3 roll: \(totalDice)", terminator: ", ")
            DispatchQueue.main.asyncAfter(deadline: .now() + delayMove) {
                moveForwardBySteps(steps: totalDice, player: &gamePlayer3)
            }
        }
        
        if (player4Turn) {
            print("player 4 roll: \(totalDice)", terminator: ", ")
            DispatchQueue.main.asyncAfter(deadline: .now() + delayMove) {
                moveForwardBySteps(steps: totalDice, player: &gamePlayer4)
            }
        }

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
    
    func resetPlayerTimer(playerId: Int, newTime: Double) {
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
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
