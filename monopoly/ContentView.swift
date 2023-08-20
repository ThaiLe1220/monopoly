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

    @State var player1TurnBegin = true
    @State var player2TurnBegin = false
    @State var player3TurnBegin = false
    @State var player4TurnBegin = false
    
    @State var timeLeft: Double = 10.0
    @State var timer: Timer?
    
//    @State var player1TurnEnd = false
//    @State var player2TurnEnd = true
//    @State var player3TurnEnd = true
//    @State var player4TurnEnd = true

    var diceColor : String {
        if player1TurnBegin {return player1.color.rawValue}
        if player2TurnBegin {return player2.color.rawValue}
        if player3TurnBegin {return player3.color.rawValue}
        return player4.color.rawValue
    }
    
    var body: some View {
        VStack{
            Spacer().frame(height: 100)
            
            /// BOARD VIEW
            ZStack() {
                
                /// TIME LEFT VIEW
                HStack {
                    Text("Time Left: \(String(format: "%.1f", timeLeft))")
                        .font(.system(size: 10, weight: .regular, design: .monospaced))
                }
                .frame(width: 100, height: 20)
                .border(.black, width: 0.3)
                .offset(x: -120 + 50, y: -120 + 10)
                    
             
                HStack {
                    Button("start") {startTimer()}
                    Button("reset") {resetTimer()}
                }

                /// DOLLARS ANIMATION
                ZStack {
                    Image(systemName: "dollarsign")
                        .font(.title2)
                        .foregroundColor(.green)
                        .offset(x: -60)
                        .rotationEffect(.degrees(dollar1 ? 360: 0))
                        .animation(.linear(duration: 6).delay(0.0).repeatForever(autoreverses: .random()), value: dollar1)
                        .onAppear(){
                            dollar1.toggle()
                        }
                    
                    Image(systemName: "dollarsign")
                        .font(.title2)
                        .foregroundColor(.green)
                        .offset(x: 60)
                        .rotationEffect(.degrees(dollar2 ? 360: 0))
                        .animation(.linear(duration: 5).delay(0.0).repeatForever(autoreverses: .random()), value: dollar2)
                        .onAppear(){
                            dollar2.toggle()
                        }
                }
                
                /// PLAYER POSITION VIEW
                ZStack {
                    Image(systemName: "pawprint.fill")
                        .offset(x: player1Tile.posX - 8, y: player1Tile.posY - 8)
                        .font(.system(size: 12))
                    .foregroundColor(Color(gamePlayer1.color.rawValue))
                    
                    Image(systemName: "pawprint.fill")
                        .offset(x: player2Tile.posX + 8, y: player2Tile.posY - 8)
                        .font(.system(size: 12))
                        .foregroundColor(Color(gamePlayer2.color.rawValue))

                    Image(systemName: "pawprint.fill")
                        .offset(x: player3Tile.posX + 8, y: player3Tile.posY + 8)
                        .font(.system(size: 13))
                        .foregroundColor(Color(gamePlayer3.color.rawValue))

                    Image(systemName: "pawprint.fill")
                        .offset(x: player4Tile.posX - 8, y: player4Tile.posY + 8)
                        .font(.system(size: 12))
                        .foregroundColor(Color(gamePlayer4.color.rawValue))

                }

                /// TILE VIEWS
                ZStack {
                    /// BOTTOM TILES
                    ZStack {
                        ZStack{
                            Text("0")
                        }
                        .frame(width: 60, height: 60)
                        .border(.black)
                        .offset(x: 150, y: 150)
                        
                        ZStack{
                            Text("1")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: 105, y: 150)
                        
                        ZStack{
                            Text("2")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: 75, y: 150)
                        ZStack{
                            Text("3")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: 45, y: 150)
                        ZStack{
                            Text("4")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: 15, y: 150)
                        ZStack{
                            Text("5")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: -15, y: 150)
                        ZStack{
                            Text("6")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: -45, y: 150)
                        ZStack{
                            Text("7")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: -75, y: 150)
                        
                        ZStack{
                            Text("8")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: -105, y: 150)
                    }
                    .font(.system(size: 12))
                    .frame(width: 360, height: 360)
                    .border(.black)
                    .rotationEffect(Angle(degrees: 0))
                    

                    /// LEFT TILES
                    ZStack {
                        ZStack{
                            Text("9")
                        }
                        .frame(width: 60, height: 60)
                        .border(.black)
                        .offset(x: 150, y: 150)
                        
                        ZStack{
                            Text("10")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: 105, y: 150)
                        
                        ZStack{
                            Text("11")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: 75, y: 150)
                        ZStack{
                            Text("12")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: 45, y: 150)
                        ZStack{
                            Text("13")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: 15, y: 150)
                        ZStack{
                            Text("14")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: -15, y: 150)
                        ZStack{
                            Text("15")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: -45, y: 150)
                        ZStack{
                            Text("16")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: -75, y: 150)
                        
                        ZStack{
                            Text("17")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: -105, y: 150)
                    }
                    .font(.system(size: 12))
                    .frame(width: 360, height: 360)
                    .border(.black)
                    .rotationEffect(Angle(degrees: 90))
                    
                  
                    /// TOP TILES
                    ZStack {
                        ZStack{
                            Text("18")
                        }
                        .frame(width: 60, height: 60)
                        .border(.black)
                        .offset(x: 150, y: 150)
                        
                        ZStack{
                            Text("19")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: 105, y: 150)
                        
                        ZStack{
                            Text("20")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: 75, y: 150)
                        ZStack{
                            Text("21")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: 45, y: 150)
                        ZStack{
                            Text("22")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: 15, y: 150)
                        ZStack{
                            Text("23")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: -15, y: 150)
                        ZStack{
                            Text("24")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: -45, y: 150)
                        ZStack{
                            Text("25")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: -75, y: 150)
                        
                        ZStack{
                            Text("26")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: -105, y: 150)
                    }
                    .font(.system(size: 12))
                    .frame(width: 360, height: 360)
                    .border(.black)
                    .rotationEffect(Angle(degrees: 180))
                    
                        
                    /// RIGHT TILES
                    ZStack {
                        ZStack{
                            Text("27")
                        }
                        .frame(width: 60, height: 60)
                        .border(.black)
                        .offset(x: 150, y: 150)
                        
                        ZStack{
                            Text("28")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: 105, y: 150)
                        
                        ZStack{
                            Text("29")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: 75, y: 150)
                        ZStack{
                            Text("30")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: 45, y: 150)
                        ZStack{
                            Text("31")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: 15, y: 150)
                        ZStack{
                            Text("32")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: -15, y: 150)
                        ZStack{
                            Text("33")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: -45, y: 150)
                        ZStack{
                            Text("34")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: -75, y: 150)
                        
                        ZStack{
                            Text("35")
                        }
                        .frame(width: 30, height: 60)
                        .border(.black)
                        .offset(x: -105, y: 150)
                    }
                    .font(.system(size: 12))
                    .frame(width: 360, height: 360)
                    .border(.black)
                    .rotationEffect(Angle(degrees: 270))
                }
               
                
            }
            
            /// DICE VIEW
            HStack() {
                Spacer()
                
                ZStack {
                    Button  {
                        let timePlaying: Double = 4
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                            player1StartTurn()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + timePlaying) {
                            player2StartTurn()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + timePlaying + 4) {
                            player3StartTurn()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + timePlaying + 8) {
                            player4StartTurn()
                        }
                        
                    } label: {
                        Image("dice\(dice1)")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(7.5)
                        Image("dice\(dice2)")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(7.5)

                    }
                }
                .frame(width: 100, height: 50)
                .border(Color(diceColor).opacity(0.6), width: 4)
                .cornerRadius(12)

        
                Spacer()
            }
            
            Spacer()

        }
        .border(.black)

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
        
        if (player1TurnBegin) {
            DispatchQueue.main.asyncAfter(deadline: .now() + delayMove) {
                moveForwardBySteps(steps: totalDice, player: &gamePlayer1)
            }
        }
        
        if (player2TurnBegin) {
            DispatchQueue.main.asyncAfter(deadline: .now() + delayMove) {
                moveForwardBySteps(steps: totalDice, player: &gamePlayer2)
            }
        }
        
        if (player3TurnBegin) {
            DispatchQueue.main.asyncAfter(deadline: .now() + delayMove) {
                moveForwardBySteps(steps: totalDice, player: &gamePlayer3)
            }
        }
        
        if (player4TurnBegin) {
            DispatchQueue.main.asyncAfter(deadline: .now() + delayMove) {
                moveForwardBySteps(steps: totalDice, player: &gamePlayer4)
            }
        }

    }
    
    func player1StartTurn(){
        turnPlayedByPLayer()
        player1TurnBegin = false
        player2TurnBegin = true
        player3TurnBegin = false
        player4TurnBegin = false
    }
    
    func player2StartTurn(){
        turnPlayedByPLayer()
        player1TurnBegin = false
        player2TurnBegin = false
        player3TurnBegin = true
        player4TurnBegin = false
    }
    
    func player3StartTurn(){
        turnPlayedByPLayer()
        player1TurnBegin = false
        player2TurnBegin = false
        player3TurnBegin = false
        player4TurnBegin = true
    }
    
    func player4StartTurn(){
        turnPlayedByPLayer()
        player1TurnBegin = true
        player2TurnBegin = false
        player3TurnBegin = false
        player4TurnBegin = false
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){ _ in
            if timeLeft >= 0.1 {
                timeLeft -= 0.1
            } else {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        timeLeft = 10.0
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
