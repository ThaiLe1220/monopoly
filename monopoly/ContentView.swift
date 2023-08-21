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
                        /// BOTTOM TILES
                        ZStack {
                            
                            /// TILE 0 - START
                            ZStack {
                                ZStack{
                                    Text("Start")
                                        .rotationEffect(Angle(degrees: -45))
                                }
                                .frame(width: 60, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: 150, y: 150)
                            }
                            
                            /// TILE 1 - GRANDA
                            ZStack {
                                ZStack (){
                                    Spacer()
                                        .frame(width: 18, height: 10)
                                        .background(.purple.opacity(0.8))
                                        .offset(x: -6, y: -25)
                                    Text("GRANDA")
                                        .frame(width: 60, height: 12)
                                        .rotationEffect(Angle(degrees: -90))
                                        .font(.system(size: 8.5, weight: .medium, design: .default))
                                        .foregroundColor(.purple)
                                        .offset(x: 9)
                                }
                                .frame(width: 30, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: 105, y: 150)
                            }
                            
                            /// TILE 2 - SEVILLE
                            ZStack {
                                ZStack{
                                    Spacer()
                                        .frame(width: 18, height: 10)
                                        .background(.purple.opacity(0.8))
                                        .offset(x: -6, y: -25)
                                    Text("SEVILLE")
                                        .frame(width: 60, height: 12)
                                        .rotationEffect(Angle(degrees: -90))
                                        .font(.system(size: 8.5, weight: .medium, design: .default))
                                        .foregroundColor(.purple)
                                        .offset(x: 9)
                                }
                                .frame(width: 30, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: 75, y: 150)
                            }
                            
                            /// TILE 3 - MADRID
                            ZStack {
                                ZStack{
                                    Spacer()
                                        .frame(width: 18, height: 10)
                                        .background(.purple.opacity(0.8))
                                        .offset(x: -6, y: -25)
                                    Text("MADRID")
                                        .frame(width: 60, height: 12)
                                        .rotationEffect(Angle(degrees: -90))
                                        .font(.system(size: 8.5, weight: .medium, design: .default))
                                        .foregroundColor(.purple)
                                        .offset(x: 9)
                                    
                                }
                                .frame(width: 30, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: 45, y: 150)
                            }
                            
                            /// TILE 4 - TAX
                            ZStack {
                                ZStack{
                                    Text("TAX")
                                        .frame(width: 30, height: 10)
                                        .border(.black, width: 0.3)
                                        .font(.system(size: 7, weight: .light, design: .monospaced))
                                }
                                .frame(width: 30, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: 15, y: 150)
                            }
                            
                            /// TILE 5 - BALI BEACH
                            ZStack {
                                ZStack{
                                    Text("BALI")
                                        .frame(width: 30, height: 10)
                                        .border(.black, width: 0.3)
                                        .font(.system(size: 7, weight: .light, design: .monospaced))
                                }
                                .frame(width: 30, height: 60)
                                .background(.brown.opacity(0.25))
                                .border(.black, width: 0.3)
                            .offset(x: -15, y: 150)
                            }

                            /// TILE 6 - HONG KONG
                            ZStack {
                                ZStack{
                                    Spacer()
                                        .frame(width: 18, height: 10)
                                        .background(.blue.opacity(0.3))
                                        .offset(x: -6, y: -25)
                                    Text("HONG KONG")
                                        .frame(width: 60, height: 12)
                                        .rotationEffect(Angle(degrees: -90))
                                        .font(.system(size: 8.5, weight: .medium, design: .default))
                                        .foregroundColor(.blue.opacity(0.6))
                                        .offset(x: 9)
                                }
                                .frame(width: 30, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: -45, y: 150)
                            }
                            
                            /// TILE 7 - BEIJING
                            ZStack {
                                ZStack{
                                    Spacer()
                                        .frame(width: 18, height: 10)
                                        .background(.blue.opacity(0.3))
                                        .offset(x: -6, y: -25)
                                    Text("BEIJING")
                                        .frame(width: 60, height: 12)
                                        .rotationEffect(Angle(degrees: -90))
                                        .font(.system(size: 8.5, weight: .medium, design: .default))
                                        .foregroundColor(.blue.opacity(0.6))
                                        .offset(x: 9)
                                }
                                .frame(width: 30, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: -75, y: 150)
                            }
                            
                            /// TILE 8 - SHANGHAI
                            ZStack {
                                ZStack{
                                    Spacer()
                                        .frame(width: 18, height: 10)
                                        .background(.blue.opacity(0.3))
                                        .offset(x: -6, y: -25)
                                    Text("SHANGHAI")
                                        .frame(width: 60, height: 12)
                                        .rotationEffect(Angle(degrees: -90))
                                        .font(.system(size: 8.5, weight: .medium, design: .default))
                                        .foregroundColor(.blue.opacity(0.6))
                                        .offset(x: 9)
                                }
                                .frame(width: 30, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: -105, y: 150)
                            }
                        }
                        .frame(width: 360, height: 360)
                        .rotationEffect(Angle(degrees: 0))
                        .font(.system(size: 8, weight: .ultraLight, design: .monospaced))

                        /// LEFT TILES
                        ZStack {
                            
                            /// TILE 9 - LOST ISLAND
                            ZStack {
                                ZStack{
                                    Text("LOST ISLAND")
                                        .rotationEffect(Angle(degrees: -45))
                                        .font(.system(size: 7, weight: .ultraLight, design: .monospaced))
                                }
                                .frame(width: 60, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: 150, y: 150)
                            }
                            
                            /// TILE 10 - VENICE
                            ZStack {
                                ZStack{
                                    Spacer()
                                        .frame(width: 18, height: 10)
                                        .background(.pink.opacity(0.6))
                                        .offset(x: -6, y: -25)
                                    Text("VENINCE")
                                        .frame(width: 60, height: 12)
                                        .rotationEffect(Angle(degrees: -90))
                                        .font(.system(size: 8.5, weight: .medium, design: .default))
                                        .foregroundColor(.pink)
                                        .offset(x: 9)
                                }
                                .frame(width: 30, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: 105, y: 150)
                            }
                            
                            /// TILE 11 - FREE MONEY
                            ZStack {
                                ZStack{
                                    Text("FREE")
                                        .frame(width: 30, height: 10)
                                        .border(.black, width: 0.3)
                                        .font(.system(size: 7, weight: .ultraLight, design: .monospaced))
                                        .offset(y: -5)
                                    Text("$100")
                                        .frame(width: 30, height: 10)
                                        .border(.black, width: 0.3)
                                        .font(.system(size: 7, weight: .ultraLight, design: .monospaced))
                                        .offset(y: 5)
                                }
                                .frame(width: 30, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: 75, y: 150)
                            }
                            
                            /// TILE 12 - MILAN
                            ZStack {
                                ZStack{
                                    Spacer()
                                        .frame(width: 18, height: 10)
                                        .background(.pink.opacity(0.6))
                                        .offset(x: -6, y: -25)
                                    Text("MILAN")
                                        .frame(width: 60, height: 12)
                                        .rotationEffect(Angle(degrees: -90))
                                        .font(.system(size: 8.5, weight: .medium, design: .default))
                                        .foregroundColor(.pink)
                                        .offset(x: 9)
                                }
                                .frame(width: 30, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: 45, y: 150)
                            }
                            
                            /// TILE 13 - ROME
                            ZStack {
                                ZStack{
                                    Spacer()
                                        .frame(width: 18, height: 10)
                                        .background(.pink.opacity(0.6))
                                        .offset(x: -6, y: -25)
                                    Text("ROME")
                                        .frame(width: 60, height: 12)
                                        .rotationEffect(Angle(degrees: -90))
                                        .font(.system(size: 8.5, weight: .medium, design: .default))
                                        .foregroundColor(.pink)
                                        .offset(x: 9)
                                }
                                .frame(width: 30, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: 15, y: 150)
                            }
                            
                            /// TILE 14 - CHANCE ?
                            ZStack {
                                ZStack{
                                    Text("CHANCE")
                                        .frame(width: 30, height: 10)
                                        .border(.black, width: 0.3)
                                        .font(.system(size: 7, weight: .ultraLight, design: .monospaced))
                                    
                                }
                                .frame(width: 30, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: -15, y: 150)
                            }
                            
                            /// TILE 15 - HAMBURG
                            ZStack {
                                ZStack{
                                    Spacer()
                                        .frame(width: 18, height: 10)
                                        .background(.orange.opacity(0.6))
                                        .offset(x: -6, y: -25)
                                    Text("HAMBURG")
                                        .frame(width: 60, height: 12)
                                        .rotationEffect(Angle(degrees: -90))
                                        .font(.system(size: 8.5, weight: .medium, design: .default))
                                        .foregroundColor(.orange)
                                        .offset(x: 9)
                                }
                                .frame(width: 30, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: -45, y: 150)
                            }
                            
                            /// TILE 16 - CYPRUS BEACH
                            ZStack {
                                ZStack{
                                    Text("CYRUS")
                                        .frame(width: 30, height: 10)
                                        .border(.black, width: 0.3)
                                        .font(.system(size: 7, weight: .ultraLight, design: .default))
                                    
                                }
                                .frame(width: 30, height: 60)
                                .background(.brown.opacity(0.25))
                                .border(.black, width: 0.3)
                            .offset(x: -75, y: 150)
                            }
                            
                            /// TILE 17- BERLIN
                            ZStack {
                                ZStack{
                                    Spacer()
                                        .frame(width: 18, height: 10)
                                        .background(.orange.opacity(0.6))
                                        .offset(x: -6, y: -25)
                                    Text("BERLIN")
                                        .frame(width: 60, height: 12)
                                        .rotationEffect(Angle(degrees: -90))
                                        .font(.system(size: 8.5, weight: .medium, design: .default))
                                        .foregroundColor(.orange)
                                        .offset(x: 9)
                                }
                                .frame(width: 30, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: -105, y: 150)
                            }
                        }
                        .frame(width: 360, height: 360)
                        .rotationEffect(Angle(degrees: 90))
                        .font(.system(size: 8, weight: .regular, design: .monospaced))
                      
                        /// TOP TILES
                        ZStack {
                            
                            /// TILE 18 - WORLD TOUR
                            ZStack {
                                ZStack{
                                    Text("WOLRD")
                                        .rotationEffect(Angle(degrees: 135))
                                        .font(.system(size: 7, weight: .ultraLight, design: .monospaced))
                                        .offset(x: 6, y: 6)
                                    
                                    Text("CHAMPIONSHIPS")
                                        .rotationEffect(Angle(degrees: 135))
                                        .font(.system(size: 7, weight: .ultraLight, design: .monospaced))
                                        .offset(x: -2, y: -2)
                                }
                                .frame(width: 60, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: 150, y: 150)
                            }
                            
                            /// TILE 19 - LONDON
                            ZStack {
                                ZStack{
                                    Spacer()
                                        .frame(width: 18, height: 10)
                                        .background(.red.opacity(0.8))
                                        .offset(x: 6, y: -25)
                                    Text("LONDON")
                                        .frame(width: 60, height: 12)
                                        .rotationEffect(Angle(degrees: -90))
                                        .font(.system(size: 8.5, weight: .medium, design: .default))
                                        .foregroundColor(.red)
                                        .offset(x: -9)
                                }
                                .frame(width: 30, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: 105, y: 150)
                            }
                            
                            /// TILE 20 - DEVON BEACH
                            ZStack {
                                ZStack{
                                    Text("DEVON")
                                        .frame(width: 30, height: 10)
                                        .border(.black, width: 0.3)
                                        .font(.system(size: 7, weight: .ultraLight, design: .monospaced))
                                        .rotationEffect(Angle(degrees: 180))
                                }
                                .frame(width: 30, height: 60)
                                .background(.brown.opacity(0.25))
                                .border(.black, width: 0.3)
                            .offset(x: 75, y: 150)
                            }
                            
                            /// TILE 21 - BATH
                            ZStack {
                                ZStack{
                                    Spacer()
                                        .frame(width: 18, height: 10)
                                        .background(.red.opacity(0.8))
                                        .offset(x: 6, y: -25)
                                    Text("BATH")
                                        .frame(width: 60, height: 12)
                                        .rotationEffect(Angle(degrees: -90))
                                        .font(.system(size: 8.5, weight: .medium, design: .default))
                                        .foregroundColor(.red)
                                        .offset(x: -9)
                                }
                                .frame(width: 30, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: 45, y: 150)
                            }
                            
                            /// TILE 22 - CAMBRIDGE
                            ZStack {
                                ZStack{
                                    Spacer()
                                        .frame(width: 18, height: 10)
                                        .background(.red.opacity(0.8))
                                        .offset(x: 6, y: -25)
                                    Text("CAMBRIDGE")
                                        .frame(width: 60, height: 12)
                                        .rotationEffect(Angle(degrees: -90))
                                        .font(.system(size: 8.5, weight: .medium, design: .default))
                                        .foregroundColor(.red)
                                        .offset(x: -9)
                                }
                                .frame(width: 30, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: 15, y: 150)
                            }
                            
                            /// TILE 23 - CHANCE
                            ZStack {
                                ZStack{
                                    Text("CHANCE")
                                        .frame(width: 30, height: 10)
                                        .border(.black, width: 0.3)
                                        .font(.system(size: 7, weight: .ultraLight, design: .monospaced))
                                        .rotationEffect(Angle(degrees: 180))
                                }
                                .frame(width: 30, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: -15, y: 150)
                            }
                            
                            /// TILE 24 - CHICAGO
                            ZStack {
                                ZStack{
                                    Spacer()
                                        .frame(width: 18, height: 10)
                                        .background(.yellow.opacity(0.3))
                                        .offset(x: 6, y: -25)
                                    Text("CHICAGO")
                                        .frame(width: 60, height: 12)
                                        .rotationEffect(Angle(degrees: -90))
                                        .font(.system(size: 8.5, weight: .medium, design: .default))
                                        .foregroundColor(.yellow)
                                        .offset(x: -9)
                                }
                                .frame(width: 30, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: -45, y: 150)
                            }
                            
                            /// TILE 25 - LAS VEGAS
                            ZStack {
                                ZStack{
                                    Spacer()
                                        .frame(width: 18, height: 10)
                                        .background(.yellow.opacity(0.3))
                                        .offset(x: 6, y: -25)
                                    Text("LAS VEGAS")
                                        .frame(width: 60, height: 12)
                                        .rotationEffect(Angle(degrees: -90))
                                        .font(.system(size: 8.5, weight: .medium, design: .default))
                                        .foregroundColor(.yellow)
                                        .offset(x: -9)
                                }
                                .frame(width: 30, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: -75, y: 150)
                            }
                            
                            /// TILE 26 - NEW YORK
                            ZStack {
                                ZStack{
                                    Spacer()
                                        .frame(width: 18, height: 10)
                                        .background(.yellow.opacity(0.3))
                                        .offset(x: 6, y: -25)
                                    Text("NEW YORK")
                                        .frame(width: 60, height: 12)
                                        .rotationEffect(Angle(degrees: -90))
                                        .font(.system(size: 8.5, weight: .medium, design: .default))
                                        .foregroundColor(.yellow)
                                        .offset(x: -9)
                                }
                                .frame(width: 30, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: -105, y: 150)
                            }
                        }
                        .frame(width: 360, height: 360)
                        .rotationEffect(Angle(degrees: 180))
                        .font(.system(size: 8, weight: .regular, design: .monospaced))
                            
                        /// RIGHT TILES
                        ZStack {
                            
                            /// TILE 27 - WORLD TOUR
                            ZStack {
                                ZStack{
                                    Text("WOLRD TOUR")
                                        .rotationEffect(Angle(degrees: 135))
                                        .font(.system(size: 7, weight: .ultraLight, design: .monospaced))
                                }
                                .frame(width: 60, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: 150, y: 150)
                            }
                            
                            /// TILE 28 - LYON
                            ZStack {
                                ZStack{
                                    Spacer()
                                        .frame(width: 18, height: 10)
                                        .background(.green.opacity(0.9))
                                        .offset(x: 6, y: -25)
                                    Text("LYON")
                                        .frame(width: 60, height: 12)
                                        .rotationEffect(Angle(degrees: 90))
                                        .font(.system(size: 8.5, weight: .medium, design: .default))
                                        .foregroundColor(.green)
                                        .offset(x: -9)
                                }
                                .frame(width: 30, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: 105, y: 150)
                            }
                            
                            /// TILE 29 - NICE BEACH
                            ZStack {
                                ZStack{
                                    Text("NICE")
                                        .frame(width: 30, height: 10)
                                        .border(.black, width: 0.3)
                                        .font(.system(size: 7, weight: .ultraLight, design: .monospaced))
                                        .rotationEffect(Angle(degrees: 180))
                                }
                                .frame(width: 30, height: 60)
                                .background(.brown.opacity(0.25))
                                .border(.black, width: 0.3)
                            .offset(x: 75, y: 150)
                            }
                            
                            /// TILE 30 - PARIS
                            ZStack {
                                ZStack{
                                    Spacer()
                                        .frame(width: 18, height: 10)
                                        .background(.green.opacity(0.9))
                                        .offset(x: 6, y: -25)
                                    Text("PARIS")
                                        .frame(width: 60, height: 12)
                                        .rotationEffect(Angle(degrees: 90))
                                        .font(.system(size: 8.5, weight: .medium, design: .default))
                                        .foregroundColor(.green)
                                        .offset(x: -9)
                                }
                                .frame(width: 30, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: 45, y: 150)
                            }
                            
                            /// TILE 31- BORDEAUX
                            ZStack {
                                ZStack{
                                    Spacer()
                                        .frame(width: 18, height: 10)
                                        .background(.green.opacity(0.9))
                                        .offset(x: 6, y: -25)
                                    Text("BORDEAUX")
                                        .frame(width: 60, height: 12)
                                        .rotationEffect(Angle(degrees: 90))
                                        .font(.system(size: 8.5, weight: .medium, design: .default))
                                        .foregroundColor(.green)
                                        .offset(x: -9)
                                    
                                }
                                .frame(width: 30, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: 15, y: 150)
                            }
                            
                            /// TILE 32 - CHANCE
                            ZStack {
                                ZStack{
                                    Text("CHANCE")
                                        .frame(width: 30, height: 10)
                                        .border(.black, width: 0.3)
                                        .font(.system(size: 7, weight: .ultraLight, design: .monospaced))
                                        .rotationEffect(Angle(degrees: 180))
                                }
                                .frame(width: 30, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: -15, y: 150)
                            }
                            
                            /// TILE 33 - OSAKA
                            ZStack {
                                ZStack{
                                    Spacer()
                                        .frame(width: 18, height: 10)
                                        .background(.blue.opacity(0.9))
                                        .offset(x: 6, y: -25)
                                    Text("OSAKA")
                                        .frame(width: 60, height: 12)
                                        .rotationEffect(Angle(degrees: 90))
                                        .font(.system(size: 8.5, weight: .medium, design: .default))
                                        .foregroundColor(.blue)
                                        .offset(x: -9)
                                }
                                .frame(width: 30, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: -45, y: 150)
                            }
                            
                            /// TILE 34 - TOKYO
                            ZStack {
                                ZStack{
                                    Spacer()
                                        .frame(width: 18, height: 10)
                                        .background(.blue.opacity(0.9))
                                        .offset(x: 6, y: -25)
                                    Text("TOKYO")
                                        .frame(width: 60, height: 12)
                                        .rotationEffect(Angle(degrees: 90))
                                        .font(.system(size: 8.5, weight: .medium, design: .default))
                                        .foregroundColor(.blue)
                                        .offset(x: -9)
                                }
                                .frame(width: 30, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: -75, y: 150)
                            }
                            
                            /// TILE 35 - TAX
                            ZStack {
                                ZStack{
                                    Text("TAX")
                                        .frame(width: 30, height: 10)
                                        .border(.black, width: 0.3)
                                        .font(.system(size: 7, weight: .light, design: .monospaced))
                                }
                                .frame(width: 30, height: 60)
                                .border(.black, width: 0.3)
                            .offset(x: -105, y: 150)
                            }
                        }
                        .frame(width: 360, height: 360)
                        .rotationEffect(Angle(degrees: 270))
                        .font(.system(size: 8, weight: .regular, design: .monospaced))
                    }
                }
                
                /// DICE VIEW
                HStack() {
                    Spacer()
                    ZStack {
                        Button  {
                            /// player 1 - start turn
                            resetPlayerTimer(playerId: 1, newTime: 10)
                            startPlayerTimer(playerId: 1)
                            player1Turn = true
                        } label: {
                            Image("dice\(dice1)")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .cornerRadius(8)
                            Image("dice\(dice2)")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .cornerRadius(8)
                        }
                    }
                    .frame(width: 100, height: 50)
                    .border(Color(diceColor).opacity(0.6), width: 4)

                    Spacer()
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
            DispatchQueue.main.asyncAfter(deadline: .now() + delayMove) {
                moveForwardBySteps(steps: totalDice, player: &gamePlayer1)
            }
        }
        
        if (player2Turn) {
            DispatchQueue.main.asyncAfter(deadline: .now() + delayMove) {
                moveForwardBySteps(steps: totalDice, player: &gamePlayer2)
            }
        }
        
        if (player3Turn) {
            DispatchQueue.main.asyncAfter(deadline: .now() + delayMove) {
                moveForwardBySteps(steps: totalDice, player: &gamePlayer3)
            }
        }
        
        if (player4Turn) {
            DispatchQueue.main.asyncAfter(deadline: .now() + delayMove) {
                moveForwardBySteps(steps: totalDice, player: &gamePlayer4)
            }
        }

    }
    
    func startPlayerTimer(playerId: Int) {
        if timer == nil {
            isTimerRunning = true
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){ _ in
                if timeLeft >= 0.1 {
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
