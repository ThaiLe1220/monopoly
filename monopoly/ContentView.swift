//
//  ContentView.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 16/08/2023.
//

import SwiftUI

struct ContentView: View {
    
    var tiles:[TilePosition] = TilePositionModel().tiles
    var turnTimeNPC: Double {
        if tileIdBefore <= 34 && tileIdAfter >= 36 {
            return 12
        }
        
        if lockedPLayerIds.contains(2) || lockedPLayerIds.contains(3) || lockedPLayerIds.contains(4) {
            return 2
        }
        
        return 6
    }
    
    @StateObject var game = GameModel()
    
    @StateObject var cities:CityModel = CityModel()
    @StateObject var beaches:BeachModel = BeachModel()
    @StateObject var players:PlayerModel = PlayerModel()

    @State var dollar1: Bool = false
    @State var dollar2: Bool = false

    @State var dice1: Int = 1
    @State var dice2: Int = 1
    var totalDice: Int { dice1 + dice2 }
    var diceAvaialble: Bool {
        if player1Turn || player2Turn || player3Turn || player4Turn
        {
        return false
        }
        else
        {
        return true
        }
    }
    
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
            return 1
        }
    }
    var currentPlayerColor : String {
        return players.players[currentGamePlayerId-1].color.rawValue
    }

    @State var timeLeft: Double = 60.0
    @State var timer: Timer?
    
    @State var isTimerRunning = false
    @State var endTurnMessage = false
    
    @State var buyingPropertyMessage = false
    @State var cityBuyingOption: Set<Int> = []
    @State var totalBuyingCost = 0
    @State var beachBoughtMessage = false
    @State var cityBoughtMessage = false

    @State var rentPaidMessage = false
    @State var paidPropertyOwnerId = 1
    @State var rentMoneyPaid = 0
    
    @State var taxPaidMessage = false
    @State var taxMoneyPaid = 0
    
    @State var moneyReceivedMessage = false
    @State var moneyReceived = 0
    
    @State var crossingStartTileMessage = false
    @State var tileIdBefore = 0
    @State var tileIdAfter = 0
    
    @State var wentToIslandTileMessage = false
    @State var lockedPLayerIds: [Int] = []
    @State var lockedinTurn: Int = 0
    @State var atIslandTileMessage = false

    @State var wentToChampionTileMessage = false
    @State var championPlayerId: Int = 1
    @State var isChampionEmpty = true
    @State var isCrownAnimating = false
    let championMultiplier: Int = 25 // 25%
    
    @State var wentToTourTileMessage = false
    @State var stepsGranted: Int = 0
    
    @State var showTileDetailedInfo = false
    @State var selectedTileId: Int = -1
    
    var body: some View {
        ZStack {

            // Turn View
            ZStack {
                
                /// TURN NUMBER TEXT VIEW
                ZStack {
                    Text("Turn \(game.game.turn)")
                        .font(.system(size: 13, weight: .semibold, design: .monospaced))
                        .offset(x: 0, y: -100)
                }
                
                /// GAME UTILITY VIEW
                ZStack {
                    /// TIME LEFT TEXT VIEW
                    ZStack {
                        HStack {
                            Text("Time: \(String(format: "%.1f", timeLeft))")
                                .font(.system(size: 9, weight: .bold, design: .monospaced))
                        }
                        .frame(width: 60, height: 16)
                        .cornerRadius(3)
                        .offset(x: -70, y: -92)
                    }
                    .opacity(player1Turn ? 1 : 0)
                    
                    /// END TURN BUTTON VIEW
                    ZStack {
                        Button {
                            endTurnMessage = true
                        } label: {
                            Text("End Turn")
                        }
                        .frame(width: 45, height: 16)
                        .background(.blue.opacity(0.9))
                        .cornerRadius(4)
                        .font(.system(size: 8, weight: .bold, design: .default))
                        .foregroundColor(.white)
                    }
                    .opacity(player1Turn ? 1 : 0)
                    .offset(x: 78, y: -92)
                    
                    /// END TURN MESSAGE VIEW
                    ZStack {
                        VStack {
                            Spacer()
                                .frame(height: 30)
                            
                            VStack (spacing: 0) {
                                Text("Do you want to end")
                                Text("your turn here ?")
                                    .padding(.top, 4)
                                
                                HStack {
                                    Button {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            endTurnMessage = false
                                            buyingPropertyMessage = false
                                            wentToTourTileMessage = false
                                        }
                                        stopPlayerTimer(playerId: 1)
                                    } label: {
                                        Text("Yes")
                                    }
                                    
                                    Button {
                                        endTurnMessage = false
                                    } label: {
                                        Text("No")
                                    }
                                }
                                .padding(.top, 4)
                            }
                            .font(.system(size: 11, weight: .semibold, design: .monospaced))
                            .frame(width: 210, height: 180)
                            .background(.white)
                            .zIndex(2)
                            
                        }
                    }
                    .opacity(endTurnMessage ? 1 : 0)
                    .frame(width: 210, height: 210)
                }
                
                /// PROPERTY BUYING & BOUGT MESSAGE VIEW
                ZStack {
                    /// BUYING MESSAGE VIEW
                    ZStack {
                        Color.gray.opacity(0.4)
                            .ignoresSafeArea()
                        ZStack {
                            if (tiles[players.players[0].tilePositionId].type == .city) {
                                VStack (spacing: 4){
                                    BuyingCityView(buyingMessage: $buyingPropertyMessage, cityBuyingOption: $cityBuyingOption, totalBuyingCost: $totalBuyingCost, cityBoughtMessage: $cityBoughtMessage, cities: cities, players: players)
                                        .padding(.vertical, 4)
                                }
                            }
                            else if (tiles[players.players[0].tilePositionId].type == .beach) {
                                VStack (spacing: 4){
                                    BuyingBeachView(buyingMessage: $buyingPropertyMessage, totalBuyingCost: $totalBuyingCost, beachBoughtMessage: $beachBoughtMessage, beaches: beaches, players: players)
                                        .padding(.vertical, 4)
                                }
                            }
                        }
                        .frame(width: 240, height: 240)
                        .background(.white)
                    }
                    .opacity(buyingPropertyMessage ? 1 : 0)
                    .animation(.linear(duration: 0.3), value: buyingPropertyMessage)

                    /// BEACH BOUGHT MESSAGE VIEW
                    ZStack {
                        VStack (spacing: 0) {
                            ForEach(beaches.beaches.filter({ $0.tileId == players.players[currentGamePlayerId-1].tilePositionId})) { beach in
                                
                                Text("\(beach.beachName) bought by \(players.players[currentGamePlayerId-1].name)")
                                    .font(.system(size: 12, weight: .heavy, design: .monospaced))
                                    .foregroundColor(.white)
                                    .frame(width: 210, height: 24)
                                    .background(Color(currentPlayerColor))
                                    .padding(.bottom, 4)

                                ZStack {
                                    VStack (spacing: 5){
                                        ForEach(1..<5, id: \.self) { index in
                                            if (index == 1) {
                                                HStack (spacing: 0){
                                                    Text("Level \(beach.currentLevel)").frame(width: 130)
                                                    Text("Rent").frame(width: 60)
                                                    Spacer()
                                                }
                                                .frame(width: 210, height: 24)
                                                .border(.black, width: 0.2)
                                                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                            }
                                            
                                            HStack (spacing: 0){
                                                Text(index < 2 ? "Own \(index) beach" : "Own \(index) beaches")
                                                    .frame(width: 130)
                                                Text("\(beach.rentByLevel[index])").frame(width: 60)
                                                Spacer()
                                            }
                                            .frame(width: 210, height: 16)
                                            .font(.system(size: 12, weight: .regular, design: .monospaced))
                                        }
                                    }
                                    
                                    VStack (spacing: 0) {
                                        Text("").frame(width: 24, height: 24)
                                        ForEach(0..<beach.currentLevel, id: \.self) { _ in
                                            Image(systemName: "checkmark.seal.fill")
                                                .font(.system(size: 13))
                                                .frame(width: 16, height: 16)
                                                .foregroundColor(Color(currentPlayerColor))
                                                .padding(.top, 5)
                                        }
                                        
                                        if (beach.currentLevel == 4) {
                                            Spacer().frame(width: 0, height: 0)
                                        }
                                        else {
                                            Spacer()
                                            
                                        }
                                    }
                                    .frame(width: 24, height: 108)
                                    .offset(x: 95)
                                }
                                .border(.black, width: 0.2)
                                .padding(.bottom, 4)

                                VStack {
                                    HStack {
                                        Text("Total amount of")
                                        Text("200$")
                                    }
                                    .font(.system(size: 13, weight: .bold, design: .default))
                                    .frame(width: 180, height: 24)
                                    .background(Color(currentPlayerColor))
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                }
                            }
                        }
                    }
                    .frame(width: 210, height: 190)
                    .offset(y: 10)
                    .opacity(beachBoughtMessage ? 1 : 0)
                    .animation(.linear(duration: 0.3), value: beachBoughtMessage)
                    
                    /// CITY BOUGHT MESSAGE VIEW
                    ZStack {
                        VStack (spacing: 0) {
                            ForEach(cities.cities.filter({ $0.tileId == players.players[currentGamePlayerId-1].tilePositionId})) { city in
                                Text("\(city.cityName) bought by \(players.players[currentGamePlayerId-1].name)")
                                    .font(.system(size: 12, weight: .heavy, design: .monospaced))
                                    .foregroundColor(.white)
                                    .frame(width: 210, height: 24)
                                    .background(Color(currentPlayerColor))
                                    .padding(.bottom, 4)

                                VStack (spacing: 3){
                                    ForEach(1..<6, id: \.self) { index in
                                        if (index == 1) {
                                            HStack (spacing: 0){
                                                Text("Level \(city.currentLevel)").frame(width: 90)
                                                Text("Rent").frame(width: 50)
                                                Text("Cost").frame(width: 50)
                                                Spacer().frame(width: 20)
                                            }
                                            .frame(width: 210, height: 24)
                                            .border(.black, width: 0.2)
                                            .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                            
                                            HStack (spacing: 0){
                                                Text("Land").frame(width: 90)
                                                Text("\(city.rentByLevel[index])").frame(width: 50)
                                                Text("\(city.costByLevel[index-1])").frame(width: 50)
                                                Image(systemName:"checkmark.seal.fill")
                                                    .opacity(cityBuyingOption.contains(index) ? 1 : 0)
                                                    .frame(width: 20)
                                                    .foregroundColor(Color(currentPlayerColor))
                                            }
                                            .frame(width: 210, height: 16)
                                            .font(.system(size: 12, weight: .regular, design: .monospaced))
                                        }
                                        else if (index == 5) {
                                            HStack (spacing: 0){
                                                Text("Hotel")
                                                    .frame(width: 90)
                                                Text("\(city.rentByLevel[index])").frame(width: 50)
                                                Text("\(city.costByLevel[index-1])").frame(width: 50)
                                                Image(systemName:"checkmark.seal.fill")
                                                    .opacity(cityBuyingOption.contains(index) ? 1 : 0)
                                                    .frame(width: 20)
                                                    .foregroundColor(Color(currentPlayerColor))
                                            }
                                            .frame(width: 210, height: 16)
                                            .font(.system(size: 12, weight: .regular, design: .monospaced))
                                        }
                                        else {
                                            HStack (spacing: 0){
                                                Text("House \(index-1)")
                                                    .frame(width: 90)
                                                Text("\(city.rentByLevel[index])").frame(width: 50)
                                                Text("\(city.costByLevel[index-1])").frame(width: 50)
                                                Image(systemName:"checkmark.seal.fill")
                                                    .opacity(cityBuyingOption.contains(index) ? 1 : 0)
                                                    .frame(width: 20)
                                                    .foregroundColor(Color(currentPlayerColor))
                                            }
                                            .frame(width: 210, height: 16)
                                            .font(.system(size: 12, weight: .regular, design: .monospaced))
                                        }
                                    }
                                }
                                .padding(.bottom, 4)
                                .border(.black, width: 0.2)
                                
                                VStack {
                                    HStack {
                                        Text("Total amount of")
                                        Text("\(totalBuyingCost)$")
                                    }
                                    .font(.system(size: 13, weight: .bold, design: .default))
                                    .frame(width: 190, height: 24)
                                    .background(Color(currentPlayerColor))
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                    .padding(.top, 4)
                                }
                            }
                        }
                    }
                    .frame(width: 210, height: 190)
                    .offset(y: 10)
                    .opacity(cityBoughtMessage ? 1 : 0)
                    .animation(.linear(duration: 0.3), value: cityBoughtMessage)
        
                }
                .zIndex(-1)

                /// PAID RENT MESSAGE VIEW
                if rentPaidMessage {
                    ZStack {
                        // PAID RENT Text
                        ZStack {
                            VStack (spacing: 2){
                                Circle()
                                    .stroke(Color(currentPlayerColor).opacity(0.8),  lineWidth: 2.5)
                                    .frame(width: 36)
                                    .padding(.bottom, 4)

                                Text("\(players.players[currentGamePlayerId-1].name)")
                                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                            }
                            .frame(width: 70, height: 100)
                            .offset(x: -70)
                            
                            VStack (spacing: 4){
                                Text("Paid")
                                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                Text("\(rentMoneyPaid)$")
                                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                    .foregroundColor(.green)
                            }
                            
                            VStack (spacing: 2){
                                Circle()
                                    .stroke(Color("\(players.players[paidPropertyOwnerId-1].color.rawValue)").opacity(0.8),  lineWidth: 2.5)
                                    .frame(width: 36)
                                    .padding(.bottom, 4)

                                Text("\(players.players[paidPropertyOwnerId-1].name)")
                                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                            }
                            .frame(width: 70, height: 100)
                            .offset(x: 70)
                        }
                        
                        // PAID RENT Arrow Animation
                        ZStack{
                            ArrowAnimationView()
                        }
                        .offset(y: -7.5)
                        .foregroundColor(.green)
                    }
                    .frame(width: 210, height: 160)
                    .offset(y: 7.5)
                    .animation(.linear(duration: 0.3), value: rentPaidMessage)
                }
                
                /// PAID TAX TEXT MESSAGE VIEW
                if taxPaidMessage {
                    ZStack {
                        // PAID TAX Text
                        ZStack {
                            VStack (spacing: 2){
                                Circle()
                                    .stroke(Color(currentPlayerColor).opacity(0.8),  lineWidth: 2.5)
                                    .frame(width: 36)
                                    .padding(.bottom, 4)
                                
                                Text("\(players.players[currentGamePlayerId-1].name)")
                                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                Text("")
                            }
                            .frame(width: 70, height: 100)
                            .offset(x: -70)
                            
                            VStack (spacing: 4){
                                Text("Paid Tax")
                                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                Text("\(taxMoneyPaid)$")
                                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                    .foregroundColor(.green)
                            }
                            
                            VStack (spacing: 2){
                                Rectangle()
                                    .stroke(.gray.opacity(0.8),  lineWidth: 2.5)
                                    .frame(width: 36, height: 36)
                                    .padding(.bottom, 4)

                                Text("Taxation")
                                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                Text("Department")
                                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                            }
                            .frame(width: 70, height: 100)
                            .offset(x: 70)
                        }
                        
                        // PAID TAX Arrow Animation
                        ZStack{
                            ArrowAnimationView()
                        }
                        .offset(y: -15)
                        .foregroundColor(.green)
                    }
                    .frame(width: 210, height: 160)
                    .offset(y: 15)
                    .animation(.linear(duration: 0.3), value: taxPaidMessage)
                }
                
                /// RECEIVE MONEY TEXT MESSAGE VIEW
                if moneyReceivedMessage {
                    ZStack {
                        // RECEIVE MONEY Text
                        ZStack {
                            VStack (spacing: 2){
                                Circle()
                                    .stroke(Color(currentPlayerColor).opacity(0.8),  lineWidth: 2.5)
                                    .frame(width: 36)
                                    .padding(.bottom, 4)

                                
                                Text("\(players.players[currentGamePlayerId-1].name)")
                                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                Text("")
                            }
                            .frame(width: 70, height: 100)
                            .offset(x: -70)
                            
                            VStack (spacing: 4){
                                Text("Receive Cash")
                                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                Text("\(moneyReceived)$")
                                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                    .foregroundColor(.green)
                            }
                            
                            VStack (spacing: 2){
                                Rectangle()
                                    .stroke(.gray.opacity(0.8),  lineWidth: 2.5)
                                    .frame(width: 36, height: 36)
                                    .padding(.bottom, 4)
                                
                                Text("RMIT")
                                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                Text("University")
                                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                            }
                            .frame(width: 70, height: 100)
                            .offset(x: 70)
                        }
                        
                        // RECEIVE MONEY Arrow Animation
                        ZStack{
                            ArrowAnimationView()
                        }
                        .offset(x: 0, y: -20)
                        .foregroundColor(.green)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))

                    }
                    .frame(width: 210, height: 160)
                    .offset(y: 15)
                    .animation(.linear(duration: 0.3), value: moneyReceivedMessage)
                }
                
                /// CROSSING START TILE MESSAGE VIEW
                if crossingStartTileMessage {
                    ZStack {
                        // CROSSING START TILE Text
                        ZStack {
                            VStack (spacing: 2){
                                Circle()
                                    .stroke(Color("\(players.players[currentGamePlayerId-1].color.rawValue)").opacity(0.8),  lineWidth: 2.5)
                                    .frame(width: 36)
                                    .padding(.bottom, 4)
                                
                                Text("\(players.players[currentGamePlayerId-1].name)")
                                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                Text("")
                            }
                            .frame(width: 70, height: 100)
                            .offset(x: -70)
                            
                            VStack (spacing: 4){
                                Text("Receive Cash")
                                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                Text(!isChampionEmpty && championPlayerId == currentGamePlayerId ? "\(250)$" : "\(200)$")
                                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                    .foregroundColor(.green)
                            }
                            
                            VStack (spacing: 2){
                                Rectangle()
                                    .stroke(.gray.opacity(0.8),  lineWidth: 2.5)
                                    .frame(width: 36, height: 36)
                                    .padding(.bottom, 4)
                                
                                Text("RMIT")
                                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                Text("University")
                                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                            }
                            .frame(width: 70, height: 100)
                            .offset(x: 70)
                        }
                        
                        // RECEIVE MONEY Arrow Animation
                        ZStack{
                            ArrowAnimationView()
                        }
                        .offset(x: 0, y: -20)
                        .foregroundColor(.green)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        
                    }
                    .frame(width: 210, height: 160)
                    .offset(y: 15)
                    .animation(.linear(duration: 0.3), value: crossingStartTileMessage)
                    .zIndex(3)
                }
                
                /// ISLAND TILE MESSAGE VIEW
                ZStack {
                    if wentToIslandTileMessage {
                        if !isChampionEmpty && championPlayerId == currentGamePlayerId {
                            VStack {
                                Text("Champion \(players.players[currentGamePlayerId-1].name) has attended RMIT Hearing")
                                    .font(.system(size: 11))
                                    .padding(.bottom, 4)
                                Text("But nothing can stop the champion")
                                    .font(.system(size: 11))
                            }
                            .opacity(wentToIslandTileMessage ? 1 : 0)
                            .animation(.linear(duration: 0.3), value: wentToIslandTileMessage)
                        }
                        else {
                            VStack {
                                Text("\(players.players[currentGamePlayerId-1].name) has attended RMIT Hearing")
                                    .font(.system(size: 11))
                                    .padding(.bottom, 4)
                                Text("Next turn movement is permitted")
                                    .font(.system(size: 11))
                            }
                            .opacity(wentToIslandTileMessage ? 1 : 0)
                            .animation(.linear(duration: 0.3), value: wentToIslandTileMessage)
                        }
                    }
                    
                    if atIslandTileMessage {
                        VStack {
                            Text("\(players.players[currentGamePlayerId-1].name) has completed RMIT Hearing")
                                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                .padding(.bottom, 4)
                            Text("Next turn movement is granted")
                                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                        }
                        .opacity(atIslandTileMessage ? 1 : 0)
                        .animation(.linear(duration: 0.3), value: atIslandTileMessage)
                    }
                }
                
                /// CHAMPION TILE MESSAGE
                ZStack {
                    if wentToChampionTileMessage {
                        VStack {
                            Text("\(players.players[currentGamePlayerId-1].name) is now a RMIT Champion")
                                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                .padding(.bottom, 4)
                            
                            Text("Can skip attending RMIT Hearing")
                                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                .padding(.bottom, 4)
                            
                            Text("Reduce tax paid & Increase cash received")
                                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                        }
                        .opacity(wentToChampionTileMessage ? 1 : 0)
                        .animation(.linear(duration: 0.3), value: wentToChampionTileMessage)
                    }
                    
                    Image(systemName: "crown.fill")
                        .rotation3DEffect(.degrees(isCrownAnimating ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                        .rotationEffect(Angle(degrees: -45))
                        .font(.system(size: 9))
                        .foregroundColor(Color(players.players[championPlayerId-1].color.rawValue))
                        .offset(x: -165, y: -165)
                        .opacity(!isChampionEmpty ? 1 : 0)
                        .animation(.linear(duration: 1.5), value: isCrownAnimating)
                        .onAppear{
                            isCrownAnimating.toggle()
                            Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
                                self.isCrownAnimating.toggle()
                            }
                        }

                }
                
                /// TOUR TILE MESSAGE
                ZStack {
                    if wentToTourTileMessage {
                        VStack (spacing: 0) {
                            Text("\(players.players[currentGamePlayerId-1].name) is in RMIT WORLD TOUR")
                                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                .padding(.bottom, 4)
                            
                            Text("Can move extra steps this turn")
                                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                .padding(.bottom, 4)
                            
                            Text("Chosen Steps: \(stepsGranted)")
                                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                .frame(width: 210, height: 16)
                                .padding(.bottom, 4)

             
                            if currentGamePlayerId != 1 {
                                HStack {
                                    Button {
                                        stepsGranted <= 19 ? stepsGranted+=1 : nil
                                    } label: {
                                        Image(systemName: "plus")
                                    }
                                    Button {
                                        stepsGranted >= 1 ? stepsGranted -= 1 : nil
                                    } label: {
                                        Image(systemName: "minus")
                                    }
                                }
                                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                .foregroundColor(.black)
                                .padding(.bottom, 4)

                                Button {
                                    wentToTourTileMessage = false
                                    moveForwardBySteps(steps: stepsGranted, player: &players.players[currentGamePlayerId-1])
                                    playerTileActions()
                                } label: {
                                    Text("Done")
                                        .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                        .foregroundColor(.red)
                                }
                            }
                            else {
                                Text("Done")
                                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                    .foregroundColor(.red)
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                            stepsGranted = Int.random(in: 0...20)
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.7) {
                                            wentToTourTileMessage = false
                                            moveForwardBySteps(steps: stepsGranted, player: &players.players[currentGamePlayerId-1])
                                            playerTileActions()
                                        }
                                }
                            }
                        }
                        .animation(.linear(duration: 0.3), value: wentToTourTileMessage)
                    }
                }

            }
            .frame(width: 210, height: 210)
//            .border(.black, width: 0.3)
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
                                /// player 1 - start turn
                                if turn  {
                                    turnPlayedByPLayer()
                                } else {
                                    /// player 2 - start turn
                                    DispatchQueue.main.asyncAfter(deadline: .now() + turnTimeNPC*0 + 1) {
                                        resetPlayerTimer(newTime: turnTimeNPC)
                                        startPlayerTimer(playerId: 2)
                                    }
                                    /// player 3 - start turn
                                    DispatchQueue.main.asyncAfter(deadline: .now() + turnTimeNPC*1 + 2) {
                                        resetPlayerTimer(newTime: turnTimeNPC)
                                        startPlayerTimer(playerId: 3)
                                    }
                                    /// player 4 - start turn
                                    DispatchQueue.main.asyncAfter(deadline: .now() + turnTimeNPC*2 + 3) {
                                        resetPlayerTimer(newTime: turnTimeNPC)
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
                    }.zIndex(99)

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
                                                .stroke(Color(currentPlayerColor).opacity(0.6),  lineWidth: 3)
                                                .frame(width: 43)
                                                .rotationEffect(.degrees(-90))
                                                .shadow(color: Color(currentPlayerColor), radius: 2)
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
                                                .stroke(Color(currentPlayerColor).opacity(0.6),  lineWidth: 3)
                                                .frame(width: 43)
                                                .rotationEffect(.degrees(-90))
                                                .shadow(color: Color(currentPlayerColor), radius: 2)
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

                        /// DICE BUTTON VIEW
                        ZStack {
                            Button  {
                                /// TURN START with Player 1 move first
                                game.game.turn += 1
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
                            .disabled(!diceAvaialble)
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
                                                .stroke(Color(currentPlayerColor).opacity(0.6),  lineWidth: 3)
                                                .frame(width: 43)
                                                .rotationEffect(.degrees(-90))
                                                .shadow(color: Color(currentPlayerColor), radius: 2)
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
                                                .stroke(Color(currentPlayerColor).opacity(0.6),  lineWidth: 3)
                                                .frame(width: 43)
                                                .rotationEffect(.degrees(-90))
                                                .shadow(color: Color(currentPlayerColor), radius: 2)
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
                
                paidPropertyOwnerId = cities.cities[index].ownerId
                rentMoneyPaid = cities.cities[index].rent
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    rentPaidMessage = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.7) {
                    rentPaidMessage = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    rentMoneyPaid = 0
                }

                print("Player \(playerId) paid \(cities.cities[index].rent) to Player  \(players.players[cities.cities[index].ownerId-1].id)")
            }
            else {
                cities.cities[index].printCityBasicInfo()
                if playerId == 1 {
                    buyingPropertyMessage = true
                }
                else {
                    buyingPropertyMessage = false
                    cities.buyCityAutomatically(player: &players.players[playerId-1], totalBuyingCost: &totalBuyingCost)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        cityBoughtMessage = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.7) {
                        cityBoughtMessage = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        totalBuyingCost = 0
                    }
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
                
                paidPropertyOwnerId = beaches.beaches[index].ownerId
                rentMoneyPaid = beaches.beaches[index].rent
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    rentPaidMessage = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.7) {
                    rentPaidMessage = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    rentMoneyPaid = 0
                }
                
                print("Player \(playerId) paid \(beaches.beaches[index].rent) to Player  \(players.players[beaches.beaches[index].ownerId-1].id)")
            }
            else {
                beaches.beaches[index].printBeachBasicInfo()
                if playerId == 1 {
                    buyingPropertyMessage = true
                }
                else {
                    buyingPropertyMessage = false
                    beaches.buyBeach(player: &players.players[playerId-1])
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        beachBoughtMessage = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.7) {
                        beachBoughtMessage = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        totalBuyingCost = 0
                    }
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

        if !isChampionEmpty && championPlayerId == currentGamePlayerId {
            taxMoneyPaid = players.players[playerId-1].money*tax/100 * (100-championMultiplier)/100
            print("Player(Champion) \(playerId) paid \(taxMoneyPaid) as Tax")
            players.players[playerId-1].money -= taxMoneyPaid
        } else {
            taxMoneyPaid = players.players[playerId-1].money*tax/100
            print("Player \(playerId) paid \(taxMoneyPaid) as Tax")
            players.players[playerId-1].money -= taxMoneyPaid
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            taxPaidMessage = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.7) {
            taxPaidMessage = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            taxMoneyPaid = 0
        }
        
        print("Player \(playerId) paid tax with \(taxMoneyPaid)")
    }
    
    func pLayerMoneyTileAction(playerId: Int) {
        print("pLayerTaxTileAction invoked() by Player \(playerId),", terminator: " ")
        moneyReceived = Int.random(in: 100...200)
        
        if !isChampionEmpty && championPlayerId == currentGamePlayerId {
            print("Player \(playerId) received \(moneyReceived) as Free Reward")
            players.players[playerId-1].money += moneyReceived
        } else {
            moneyReceived = moneyReceived * (100+championMultiplier)/100
            print("Player(Champion) \(playerId) received \(moneyReceived) as Free Reward")
            players.players[playerId-1].money += moneyReceived
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            moneyReceivedMessage = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.7) {
            moneyReceivedMessage = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            moneyReceived = 0
        }
        
        print("Player \(playerId) receive money of \(moneyReceived)")
    }

    func playerTileActions() {
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
        else if (tiles[players.players[currentGamePlayerId-1].tilePositionId].type == .island) {
            if !isChampionEmpty && championPlayerId == currentGamePlayerId {
                
                print("Player(Champion) \(currentGamePlayerId) is not added to lockedPLayerIds in turn \(game.game.turn)")
            }
            else {
                lockedPLayerIds.append(currentGamePlayerId)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    wentToIslandTileMessage = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.7) {
                    wentToIslandTileMessage = false
                }
                lockedinTurn = game.game.turn
                print("Player \(currentGamePlayerId) is added to lockedPLayerIds in turn \(game.game.turn)")
            }
            
            
        }
        else if (tiles[players.players[currentGamePlayerId-1].tilePositionId].type == .champion) {
            championPlayerId = currentGamePlayerId
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                wentToChampionTileMessage = true
                isChampionEmpty = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.7) {
                wentToChampionTileMessage = false
            }
            print("Player \(currentGamePlayerId) is RMIT new Champion")
        }
        else if (tiles[players.players[currentGamePlayerId-1].tilePositionId].type == .tour) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                
                wentToTourTileMessage = true
            }
        }
        
    }
    
    func turnPlayedByPLayer() {
        var delayRoll:Double = 0
        for _ in 0..<10 {
            withAnimation(.easeIn(duration: 0.1).delay(delayRoll)){
                dice1 = diceRoll(num: dice1)
                dice2 = diceRoll(num: dice2)
                delayRoll += 0.1
            }
        }
        print("\nplayer \(currentGamePlayerId) roll: \(totalDice)", terminator: ", ")

        tileIdBefore = players.players[currentGamePlayerId-1].tilePositionId
        tileIdAfter = tileIdBefore + totalDice
        if lockedPLayerIds.contains(currentGamePlayerId) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                atIslandTileMessage = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.7) {
                atIslandTileMessage = false
            }
            if game.game.turn - lockedinTurn == 1 {
                if let index = lockedPLayerIds.firstIndex(of: currentGamePlayerId) {
                    lockedPLayerIds.remove(at: index)
                    print("Player \(currentGamePlayerId) is removed from lockedPLayerIds in turn \(game.game.turn)")
                }
                moveForwardBySteps(steps: 0, player: &players.players[currentGamePlayerId-1])
            }
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                if tileIdBefore <= 34 && tileIdAfter >= 36 {
                    moveForwardBySteps(steps: totalDice, player: &players.players[currentGamePlayerId-1])
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        crossingStartTileMessage = true
                    }
                    if !isChampionEmpty && championPlayerId == currentGamePlayerId {
                        print("Player(Champion) \(currentGamePlayerId) crossing Start Tile", terminator: ", ")
                        players.players[currentGamePlayerId-1].money += 250
                        print("and receive 250$", terminator: ", ")
                    } else {
                        print("Player \(currentGamePlayerId) crossing Start Tile", terminator: ", ")
                        players.players[currentGamePlayerId-1].money += 200
                        print("and receive 200$", terminator: ", ")
                    }
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.7) {
                        withAnimation(.linear(duration: 0.3)){
                            crossingStartTileMessage = false
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        playerTileActions()
                    }
                }
                else {
                    moveForwardBySteps(steps: totalDice, player: &players.players[currentGamePlayerId-1])
                    playerTileActions()
                }
            }
        }
        
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
