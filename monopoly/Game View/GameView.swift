
/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 2
  Author: Le Hong Thai
  ID: s3752577
  Created  date: 16/08/2023
  Last modified: 8/09/2023
  Acknowledgement: Acknowledge the resources that you use here.
*/


import SwiftUI

struct GameView: View {
    
    // Persist game and games data across app launches
    @AppStorage("game") private var gameData: Data = Data()
    @AppStorage("games") private var gamesData: Data = Data()
    
    // Initialize game-related models
    var tiles:[TilePosition] = TilePositionModel().tiles
    @StateObject var game = GameModel()

    // States related to currency in the game
    @StateObject var cities:CityModel = CityModel()
    @StateObject var beaches:BeachModel = BeachModel()
    @StateObject var players:PlayerModel = PlayerModel()
    @StateObject var achievements:AchievementModel = AchievementModel()
    
    // Dice states
    @State var dollar1: Bool = false
    @State var dollar2: Bool = false

    @State var dice1: Int = 1
    @State var dice2: Int = 1
    var totalDice: Int { dice1 + dice2 }
    var diceAvaialble: Bool {
        player1Turn || player2Turn || player3Turn || player4Turn ? false : true
    }
    
    // Player positions and turns
    @State var player1Tile = startingPosition
    @State var player2Tile = startingPosition
    @State var player3Tile = startingPosition
    @State var player4Tile = startingPosition

    @State var player1Turn = false
    @State var player2Turn = false
    @State var player3Turn = false
    @State var player4Turn = false
    
    // Current Player Info
    var currentGamePlayerId: Int{
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
    
    var currentPlayerColor: String {
        return players.players[currentGamePlayerId-1].color.rawValue
    }
    var currentPlayerTileId: Int {
        return players.players[currentGamePlayerId-1].tilePositionId
    }
    var currentPlayerMoney: Int {
        return players.players[currentGamePlayerId-1].money
    }
    var currentPlayerName: String {
        return players.players[currentGamePlayerId-1].name
    }

    // Timer-related states
    @State var timeLeft: Double = 60.0
    @State var timer: Timer?
    var turnTimeNPC: Double {
        if players.players[currentGamePlayerId-1].money < 0 {
            return 1
        }
        
        if currentPlayerTileId == 0 {
            return 8
        }
        
        if tileIdBefore <= 34 && tileIdAfter >= 36 {
            return 16
        }
        
        if currentPlayerTileId == 27 {
            return 24
        }
            
        if lockedPLayerIds.contains(2) && currentGamePlayerId == 2 || lockedPLayerIds.contains(3) && currentGamePlayerId == 3 || lockedPLayerIds.contains(4) && currentGamePlayerId == 4 {
            return 4
        }
        
        return 8
    
    }
    
    // Flags for showing various messages or dialogs
    @State var isTimerRunning = false
    @State var endTurnMessage = false
    // ... similar lines for other messages like rentPaidMessage, taxPaidMessage, etc.
    
    // Gameplay-related states
    @State var buyingPropertyMessage = false
    @State var cityBuyingOption: Set<Int> = []
    @State var totalBuyingCost = 0
    // ... similar lines for other gameplay-related states

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
    
    // States for various game events
    @State var wentToIslandTileMessage = false
    @State var lockedPLayerIds: [Int] = []
    @State var lockedinTurn: Int = 0
    @State var atIslandTileMessage = false
    // ... similar lines for other game events like wentToChampionTileMessage, etc.

    @State var wentToChampionTileMessage = false
    @State var championPlayerId: Int = 1
    @State var isChampionEmpty = true
    @State var isCrownAnimating = false
    let championMultiplier: Int = 25 // 25%
    
    @State var wentToTourTileMessage = false
    @State var stepsGranted: Int = 0
    
    // UI-related states - Not Implemented
    @State var showTileDetailedInfo = false
    @State var selectedTileId: Int = -1

    // Game End States
    @State var bankruptMessage: Bool = false
    @State var bankruptPlayerName: String = ""
    @State var bankruptPlayerColor: String = ""
    @State var gameOver: Bool = false
    @State var gameWin: Bool = false
    @State var endTurn: Bool = false
    
    // Miscellaneous
    @State var showingInfo = false
    @State var newAchievement = false
    @State var latestAchievement: Achievement = testAchievemnt
    @State var showProgress: Bool = false
    
    // Binding for dismissing the view
    @Binding var isPresented: Bool
    
    var body: some View {
        
        
        ZStack {
            /// NAVIGATION BAR
            HStack (spacing: 0) {
                Button(action: {
                    isPresented.toggle()
                }) {
                    Image(systemName: "arrowshape.turn.up.forward.fill")
                        .resizable()
                        .rotation3DEffect(Angle(degrees: 180), axis: (x: 0, y: 1, z: 0))
                        .frame(width: 20, height: 15)
                }
                .padding(8)
                
                Spacer()
                Text("score")
                Text(": \(game.game.score)")
                Spacer()
                Button(action: {
                    showingInfo.toggle()
                }) {
                    Image(systemName: "info.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .sheet(isPresented: $showingInfo) {
                    HowToPlayView()
                }
                .padding(8)
            }
            .frame(width: 361.4, height: 30)
            .font(.system(size: 14, weight: .semibold, design: .monospaced))
            .border(.black.opacity(0.8), width: 1.4)
            .offset(y: -UIScreen.main.bounds.height/2 + 60)
            
                /// GAME BOARD VIEW
            ZStack {
                    /// MONOLOPY LOGO
                ZStack {
                    Image("monolopyLogo")
                        .resizable()
                        .frame(width: 220, height: 32)
                        .rotationEffect(Angle(degrees: 45))
                }
                .offset(y: -245)
                .zIndex(-1)
                
                    /// TURN VIEW
                ZStack {
                        /// ACHIEVEMENT MESSAGE VIEW
                    ZStack {
                        HStack (spacing:0) {
                            VStack {
                                Text("new-achievement")
                                Text(latestAchievement.title)
                            }
                            .frame(width: 180, height: 60)
                            Image("badge\(latestAchievement.id)")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                    }
                    .frame(width: 220, height: 60)
                    .border(.black, width: 0.3)
                    .background(Color("BabyWhite"))
                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                    .offset(y: -11)
                    .zIndex(99)
                    .opacity(newAchievement ? 1 : 0)
                    .animation(.linear(duration: 0.3), value: newAchievement)

                        /// GAME UTILITY VIEW
                    ZStack {
                            /// TURN NUMBER TEXT VIEW
                        ZStack {
                            HStack {
                                Image("rmit-logo")
                                    .resizable()
                                    .rotationEffect(Angle(degrees: -90))
                                    .frame(width: 15, height: 15)
                                    .padding(.horizontal, -8)
                                Text("turn")
                                Text("\(game.game.turn)")
                                Image("rmit-logo")
                                    .resizable()
                                    .rotationEffect(Angle(degrees: -90))
                                    .frame(width: 15, height: 15)
                                    .padding(.horizontal, -8)
                            }
                        }
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .offset(x: 0, y: -110)
                        .foregroundColor(Color(currentPlayerColor))
                        
                            /// TIME LEFT TEXT VIEW
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: 62, height: 18)
                                .foregroundColor(.gray)
                            
                            HStack (spacing:0) {
                                Text("time")
                                Text(":\(String(format: "%.0f", timeLeft))")
                            }
                            .font(.system(size: 9.5, weight: .semibold, design: .monospaced))
                            .frame(width: 60, height: 16)
                            .background(Color("BabyWhite"))
                            .cornerRadius(4)
                            .foregroundColor(.black)
                            
                            
                        }
                        .offset(x: -75, y: -110)
//                        .opacity(player1Turn ? 1 : 0)
                        
                            /// END TURN BUTTON VIEW
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: 62, height: 18)
                                .foregroundColor(.gray)
                            
                            Button {
                                endTurnMessage = true
                            } label: {
                                Text("end-turn")
                            }
                            .font(.system(size: 9.5, weight: .semibold, design: .default))
                            .frame(width: 60, height: 16)
                            .background(Color("BabyWhite"))
                            .cornerRadius(4)
                            .foregroundColor(.black)
                        }
                        .offset(x: 75, y: -110)
                        .opacity(player1Turn ? 1 : 0)
                        
                            /// END TURN MESSAGE VIEW
                        ZStack {
                            VStack (spacing: 0) {
                                Text("do-you-want-to-end")
                                Text("your-turn-here")
                                    .padding(.top, 4)
                                
                                HStack {
                                    Button {
                                        endTurnMessage = false
                                        buyingPropertyMessage = false
                                        wentToTourTileMessage = false
                                        stopPlayerTimer(playerId: currentGamePlayerId)
                                    } label: {
                                        Text("yes")
                                    }
                                    
                                    Button {
                                        endTurnMessage = false
                                    } label: {
                                        Text("no")
                                    }
                                }
                                .padding(.top, 4)
                            }
                            .font(.system(size: 11, weight: .semibold, design: .monospaced))
                        }
                        .frame(width: 220, height: 80)
                        .background(Color("BabyWhite"))
                        .border(.black, width: 0.3)
                        .offset(y: -15)
                        .opacity(endTurnMessage ? 1 : 0)
                    }
                    
                        /// PROPERTY BUYING/BOUGT & TAX/MONEY MESSAGE VIEW
                    ZStack {
                            /// BUYING MESSAGE VIEW
                        ZStack {
                            ZStack {
                                if (tiles[players.players[0].tilePositionId].type == .city) {
                                    Rectangle()
                                        .fill(Color("BabyWhite"))
                                        .frame(width: 210, height: 180)
                                    
                                    BuyingCityView(buyingMessage: $buyingPropertyMessage, cityBuyingOption: $cityBuyingOption, totalBuyingCost: $totalBuyingCost, cityBoughtMessage: $cityBoughtMessage, cities: cities, players: players)
                                }
                                else if (tiles[players.players[0].tilePositionId].type == .beach) {
                                    Rectangle()
                                        .fill(Color("BabyWhite"))
                                        .frame(width: 210, height: 170)
                                    
                                    BuyingBeachView(buyingMessage: $buyingPropertyMessage, totalBuyingCost: $totalBuyingCost, beachBoughtMessage: $beachBoughtMessage, beaches: beaches, players: players)
                                    
                                }
                            }
                        }
                        .opacity(buyingPropertyMessage ? 1 : 0)
                        .animation(.linear(duration: 0.3), value: buyingPropertyMessage)
                        .offset(y: -5)
                        
                            /// BEACH BOUGHT MESSAGE VIEW
                        ZStack {
                            Rectangle()
                                .fill(Color("BabyWhite"))
                                .frame(width: 210, height: 160)
                            
                            VStack (spacing: 0) {
                                ForEach(beaches.beaches.filter({ $0.tileId == players.players[currentGamePlayerId-1].tilePositionId})) { beach in
                                    
                                    HStack (spacing:0) {
                                        Text("\(beach.beachName) ")
                                        Text("bought-by")
                                        Text(" \(currentPlayerName)")
                                    }
                                    .font(.system(size: 12, weight: .heavy, design: .monospaced))
                                    .foregroundColor(.white)
                                    .frame(width: 210, height: 24)
                                    .background(Color(currentPlayerColor))
                                    .padding(.bottom, 4)
                                    
                                    ZStack {
                                        VStack (spacing: 4){
                                            ForEach(1..<5, id: \.self) { index in
                                                if (index == 1) {
                                                    HStack (spacing: 0){
                                                        HStack (spacing: 0) {
                                                            Text("level")
                                                            Text(" \(beach.currentLevel)")
                                                        }
                                                        .frame(width: 130)
                                                        Text("rent").frame(width: 60)
                                                        Spacer()
                                                    }
                                                    .frame(width: 210, height: 24)
                                                    .border(.black, width: 0.2)
                                                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                                }
                                                
                                                HStack (spacing: 0) {
                                                    HStack (spacing: 0) {
                                                        Text("own")
                                                        Text(" \(index) ")
                                                        Text(index < 2 ? "beach" : "beaches")
                                                    }
                                                    .frame(width: 130)
                                                    
                                                    Text("\(beach.rentByLevel[index])$").frame(width: 60)
                                                    Spacer()
                                                }
                                                .frame(width: 210, height: 16)
                                                .font(.system(size: 12, weight: .regular, design: .monospaced))
                                            }
                                        }
                                        .padding(.bottom, 4)
                                        
                                        
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
                                        HStack (spacing:0) {
                                            Text("total-amount-of")
                                            Text(" 200$")
                                        }
                                        .font(.system(size: 13, weight: .bold, design: .default))
                                        .frame(width: 180, height: 24)
                                        .background(Color(currentPlayerColor))
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                    }
                                    .padding(.bottom, 4)
                                    
                                }
                            }
                            .border(.black, width: 0.2)
                            
                        }
                        .opacity(beachBoughtMessage ? 1 : 0)
                        .animation(.linear(duration: 0.3), value: beachBoughtMessage)
                        
                            /// CITY BOUGHT MESSAGE VIEW
                        ZStack {
                            Rectangle()
                                .fill(Color("BabyWhite"))
                                .frame(width: 210, height: 180)
                            
                            VStack (spacing: 0) {
                                ForEach(cities.cities.filter({ $0.tileId == players.players[currentGamePlayerId-1].tilePositionId})) { city in
                                    HStack (spacing:0) {
                                        Text("\(city.cityName) ")
                                        Text("bought-by")
                                        Text(" \(currentPlayerName)")
                                    }
                                    .font(.system(size: 12, weight: .heavy, design: .monospaced))
                                    .foregroundColor(.white)
                                    .frame(width: 210, height: 24)
                                    .background(Color(currentPlayerColor))
                                    .padding(.bottom, 4)
                                    
                                    VStack (spacing: 3){
                                        ForEach(1..<6, id: \.self) { index in
                                            if (index == 1) {
                                                HStack (spacing: 0){
                                                    HStack (spacing: 0) {
                                                        Text("level")
                                                        Text(" \(city.currentLevel)")
                                                    }
                                                    .frame(width: 90)
                                                    Text("rent").frame(width: 50)
                                                    Text("cost").frame(width: 50)
                                                    Spacer().frame(width: 20)
                                                }
                                                .frame(width: 210, height: 24)
                                                .border(.black, width: 0.2)
                                                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                                
                                                HStack (spacing: 0){
                                                    Text("land").frame(width: 90)
                                                    Text("\(city.rentByLevel[index])$").frame(width: 50)
                                                    Text("\(city.costByLevel[index-1])$").frame(width: 50)
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
                                                    Text("hotel")
                                                        .frame(width: 90)
                                                    Text("\(city.rentByLevel[index])$").frame(width: 50)
                                                    Text("\(city.costByLevel[index-1])$").frame(width: 50)
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
                                                    HStack(spacing: 0) {
                                                        Text("house")
                                                        Text(" \(index-1)")
                                                    }
                                                    .frame(width: 90)
                                                    
                                                    Text("\(city.rentByLevel[index])$").frame(width: 50)
                                                    Text("\(city.costByLevel[index-1])$").frame(width: 50)
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
                                        HStack (spacing:0) {
                                            Text("total-amount-of")
                                            Text(" \(totalBuyingCost)$")
                                        }
                                        .font(.system(size: 13, weight: .bold, design: .default))
                                        .frame(width: 190, height: 24)
                                        .background(Color(currentPlayerColor))
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                        .padding(.top, 4)
                                    }
                                    .padding(.bottom, 4)
                                    
                                }
                            }
                            .border(.black, width: 0.2)
                            
                        }
                        .offset(y: -5)
                        .opacity(cityBoughtMessage ? 1 : 0)
                        .animation(.linear(duration: 0.3), value: cityBoughtMessage)
                        
                            /// PAID RENT + TAX // RECEIVE MONEY MESSAGE
                        ZStack {
                                /// PAID RENT MESSAGE VIEW
                            if rentPaidMessage {
                                Rectangle()
                                    .fill(Color("BabyWhite"))
                                    .frame(width: 220, height: 140)
                                    .border(.black, width: 0.3)
                                    .offset(y: -20)
                                
                                ZStack {
                                        // PAID RENT Text
                                    ZStack {
                                        VStack (spacing: 2){
                                            ZStack {
                                                Circle()
                                                    .stroke(Color(currentPlayerColor).opacity(0.8),  lineWidth: 2.5)
                                                    .frame(width: 42)
                                                    .padding(.bottom, 4)
                                                
                                                Circle()
                                                    .stroke(.white, lineWidth: 2)
                                                    .frame(width: 38)
                                                    .padding(.bottom, 4)
                                                
                                                Image ("profile\(currentGamePlayerId)")
                                                    .resizable()
                                                    .frame(width: 36, height: 36)
                                                    .clipShape(Circle())
                                                    .padding(.bottom, 4)
                                            }
                                            
                                            Text("\(players.players[currentGamePlayerId-1].name)")
                                                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                        }
                                        .offset(x: -70)
                                        
                                        VStack (spacing: 4){
                                            Text("paid rent")
                                                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                            Text("\(rentMoneyPaid)$")
                                                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                                                .foregroundColor(.green)
                                        }
                                        
                                        VStack (spacing: 2){
                                            ZStack {
                                                Circle()
                                                    .stroke(Color("\(players.players[paidPropertyOwnerId-1].color.rawValue)").opacity(0.8),  lineWidth: 2.5)
                                                    .frame(width: 42)
                                                    .padding(.bottom, 4)
                                                
                                                Circle()
                                                    .stroke(.white, lineWidth: 2)
                                                    .frame(width: 38)
                                                    .padding(.bottom, 4)
                                                
                                                Image ("profile\(paidPropertyOwnerId)")
                                                    .resizable()
                                                    .frame(width: 36, height: 36)
                                                    .clipShape(Circle())
                                                    .padding(.bottom, 4)
                                            }
                                            
                                            Text("\(players.players[paidPropertyOwnerId-1].name)")
                                                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                        }
                                        .offset(x: 70)
                                    }
                                    
                                        // PAID RENT Arrow Animation
                                    ZStack{
                                        ArrowAnimationView()
                                    }
                                    .offset(y: -7.5)
                                    .foregroundColor(.green)
                                }
                                .offset(y: -10)
                                .animation(.linear(duration: 0.3), value: rentPaidMessage)
                                .padding(.horizontal, 4)
                            }
                            
                                /// PAID TAX TEXT MESSAGE VIEW
                            if taxPaidMessage {
                                Rectangle()
                                    .fill(Color("BabyWhite"))
                                    .frame(width: 220, height: 140)
                                    .border(.black, width: 0.3)
                                    .offset(y: -20)
                                
                                ZStack {
                                        // PAID TAX Text
                                    ZStack {
                                        VStack (spacing: 2){
                                            ZStack {
                                                Circle()
                                                    .stroke(Color(currentPlayerColor).opacity(0.8),  lineWidth: 2.5)
                                                    .frame(width: 42)
                                                    .padding(.bottom, 4)
                                                
                                                Circle()
                                                    .stroke(.white, lineWidth: 2)
                                                    .frame(width: 38)
                                                    .padding(.bottom, 4)
                                                
                                                Image ("profile\(currentGamePlayerId)")
                                                    .resizable()
                                                    .frame(width: 36, height: 36)
                                                    .clipShape(Circle())
                                                    .padding(.bottom, 4)
                                            }
                                            
                                            Text("\(players.players[currentGamePlayerId-1].name)")
                                                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                            Text("")
                                        }
                                        .frame(width: 70, height: 100)
                                        .offset(x: -70)
                                        
                                        VStack (spacing: 4){
                                            Text("paid-tax")
                                                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                            Text("\(taxMoneyPaid)$")
                                                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                                                .foregroundColor(.green)
                                        }
                                        
                                        VStack (spacing: 2){
                                            Image("rmit-logo")
                                                .resizable()
                                                .frame(width: 42, height: 42)
                                            
                                            Text("RMIT")
                                                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                            Text("University")
                                                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                        }
                                        .frame(width: 70, height: 100)
                                        .offset(x: 70, y: -5)
                                    }
                                    
                                        // PAID TAX Arrow Animation
                                    ZStack{
                                        ArrowAnimationView()
                                    }
                                    .offset(y: -15)
                                    .foregroundColor(.green)
                                }
                                .offset(y: -10)
                                .animation(.linear(duration: 0.3), value: taxPaidMessage)
                                .padding(.horizontal, 4)
                            }
                            
                                /// RECEIVE MONEY TEXT MESSAGE VIEW
                            if moneyReceivedMessage {
                                Rectangle()
                                    .fill(Color("BabyWhite"))
                                    .frame(width: 220, height: 140)
                                    .border(.black, width: 0.3)
                                    .offset(y: -20)
                                
                                ZStack {
                                        // RECEIVE MONEY Text
                                    ZStack {
                                        VStack (spacing: 2){
                                            ZStack {
                                                Circle()
                                                    .stroke(Color(currentPlayerColor).opacity(0.8),  lineWidth: 2.5)
                                                    .frame(width: 42)
                                                    .padding(.bottom, 4)
                                                
                                                Circle()
                                                    .stroke(.white, lineWidth: 2)
                                                    .frame(width: 38)
                                                    .padding(.bottom, 4)
                                                
                                                Image ("profile\(currentGamePlayerId)")
                                                    .resizable()
                                                    .frame(width: 36, height: 36)
                                                    .clipShape(Circle())
                                                    .padding(.bottom, 4)
                                            }
                                            
                                            Text("\(players.players[currentGamePlayerId-1].name)")
                                                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                            Text("")
                                        }
                                        .frame(width: 70, height: 100)
                                        .offset(x: -70)
                                        
                                        VStack (spacing: 4){
                                            Text("receive-cash")
                                                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                            Text("\(moneyReceived)$")
                                                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                                                .foregroundColor(.green)
                                        }
                                        
                                        VStack (spacing: 2){
                                            Image("rmit-logo")
                                                .resizable()
                                                .frame(width: 42, height: 42)
                                            
                                            Text("RMIT")
                                                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                            Text("University")
                                                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                        }
                                        .frame(width: 70, height: 100)
                                        .offset(x: 70, y: -5)
                                    }
                                    
                                        // RECEIVE MONEY Arrow Animation
                                    ZStack{
                                        ArrowAnimationView()
                                    }
                                    .offset(x: 0, y: -20)
                                    .foregroundColor(.green)
                                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                                }
                                .offset(y: 0)
                                .animation(.linear(duration: 0.3), value: moneyReceivedMessage)
                                .padding(.horizontal, 4)
                            }
                            
                                /// CROSSING START TILE MESSAGE VIEW
                            if crossingStartTileMessage {
                                Rectangle()
                                    .fill(Color("BabyWhite"))
                                    .frame(width: 220, height: 140)
                                    .border(.black, width: 0.3)
                                    .offset(y: -20)
                                
                                ZStack {
                                        // CROSSING START TILE Text
                                    ZStack {
                                        VStack (spacing: 2){
                                            ZStack {
                                                Circle()
                                                    .stroke(Color(currentPlayerColor).opacity(0.8),  lineWidth: 2.5)
                                                    .frame(width: 42)
                                                    .padding(.bottom, 4)
                                                
                                                Circle()
                                                    .stroke(.white, lineWidth: 2)
                                                    .frame(width: 38)
                                                    .padding(.bottom, 4)
                                                
                                                Image ("profile\(currentGamePlayerId)")
                                                    .resizable()
                                                    .frame(width: 36, height: 36)
                                                    .clipShape(Circle())
                                                    .padding(.bottom, 4)
                                            }
                                            
                                            Text("\(players.players[currentGamePlayerId-1].name)")
                                                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                            Text("")
                                        }
                                        .frame(width: 70, height: 100)
                                        .offset(x: -70)
                                        
                                        VStack (spacing: 4){
                                            Text("receive-cash")
                                                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                            Text(!isChampionEmpty && championPlayerId == currentGamePlayerId ? "\(250)$" : "\(200)$")
                                                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                                                .foregroundColor(.green)
                                        }
                                        
                                        VStack (spacing: 2){
                                            Image("rmit-logo")
                                                .resizable()
                                                .frame(width: 42, height: 42)
                                            
                                            Text("RMIT")
                                                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                            Text("University")
                                                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                        }
                                        .frame(width: 70, height: 100)
                                        .offset(x: 70, y: -5)
                                    }
                                    
                                        // RECEIVE MONEY Arrow Animation
                                    ZStack{
                                        ArrowAnimationView()
                                    }
                                    .offset(x: 0, y: -15)
                                    .foregroundColor(.green)
                                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                                    
                                }
                                .offset(y: -5)
                                .animation(.linear(duration: 0.3), value: crossingStartTileMessage)
                                .zIndex(99)
                                .padding(.horizontal, 4)
                            }
                        }
                    }
                    .zIndex(-1)
                    
                        /// SPECIAL TILE MESSAGE VIEW (ISLAND + CHAMPION + TOUR)
                    ZStack {
                            /// ISLAND TILE MESSAGE VIEW
                        ZStack {
                            if wentToIslandTileMessage {
                                Rectangle()
                                    .fill(Color("BabyWhite"))
                                    .frame(width: 220, height: 100)
                                    .border(.black, width: 0.3)
                                    .offset(y: -20)
                                
                                if !isChampionEmpty && championPlayerId == currentGamePlayerId {
                                    VStack (spacing: 4) {
                                        Text(" \(currentPlayerName) ")
                                            .foregroundColor(Color(currentPlayerColor))
                                        Text("has-attended-rmit-hearing")
                                            .padding(.bottom, 6)
                                        Text("but-nothing-can-stop-the-champion")
                                    }
                                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                    .animation(.linear(duration: 0.3), value: wentToIslandTileMessage)
                                    .padding(.horizontal, 4)
                                    .offset(y: -25)
                                }
                                else {
                                    VStack (spacing: 4) {
                                        Text("\(currentPlayerName) ")
                                            .foregroundColor(Color(currentPlayerColor))
                                        Text("has-attended-rmit-hearing")
                                            .padding(.bottom, 6)
                                        Text("next-turn-movement-is-blocked")
                                    }
                                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                    .animation(.linear(duration: 0.3), value: wentToIslandTileMessage)
                                    .padding(.horizontal, 4)
                                    .offset(y: -25)
                                }
                            }
                            
                            if atIslandTileMessage {
                                Rectangle()
                                    .fill(Color("BabyWhite"))
                                    .frame(width: 220, height: 100)
                                    .border(.black, width: 0.3)
                                    .offset(y: -20)
                                
                                ZStack {
                                    VStack (spacing: 4) {
                                        Text("\(currentPlayerName) ")
                                            .foregroundColor(Color(currentPlayerColor))
                                        
                                        Text("has-completed-rmit-hearing")
                                            .padding(.bottom, 6)
                                        Text("next-turn-movement-is-granted")
                                    }
                                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                    .animation(.linear(duration: 0.3), value: atIslandTileMessage)
                                }
                                .offset(y: -25)
                            }
                        }
                        
                            /// CHAMPION TILE MESSAGE VIEW
                        ZStack {
                            if wentToChampionTileMessage {
                                Rectangle()
                                    .fill(Color("BabyWhite"))
                                    .frame(width: 220, height: 120)
                                    .border(.black, width: 0.3)
                                    .offset(y: -20)
                                
                                ZStack {
                                    VStack (alignment: .leading, spacing: 6) {
                                        HStack (alignment: .top, spacing: 0) {
                                            Text("\(currentPlayerName) ")
                                                .foregroundColor(Color(currentPlayerColor))
                                            Text("is-now-a-rmit-champion")
                                        }
                                        Text("can-skip-session-at-hearing")
                                        Text("reduce-tax-paid-and")
                                        Text("increase-cash-received")
                                    }
                                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                    .animation(.linear(duration: 0.3), value: wentToChampionTileMessage)
                                }
                                .padding(.horizontal, 4)
                                .offset(y: -25)
                            }
                            
                            Image(systemName: "crown.fill")
                                .rotation3DEffect(.degrees(isCrownAnimating ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                                .rotationEffect(Angle(degrees: -45))
                                .font(.system(size: 9))
                                .foregroundColor(!isChampionEmpty ? Color(players.players[championPlayerId-1].color.rawValue) : .gray)
                                .offset(x: -168, y: -178)
                                .animation(.linear(duration: 1.5), value: isCrownAnimating)
                                .onAppear{
                                    isCrownAnimating.toggle()
                                    Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
                                        self.isCrownAnimating.toggle()
                                    }
                                }
                        }
                        
                            /// TOUR TILE MESSAGE VIEW
                        ZStack {
                            if wentToTourTileMessage {
                                Rectangle()
                                    .fill(Color("BabyWhite"))
                                    .frame(width: 220, height: 120)
                                    .border(.black, width: 0.3)
                                    .offset(y: -20)
                                
                                ZStack {
                                    VStack (spacing: 0) {
                                        HStack (alignment: .top, spacing: 0) {
                                            Text("\(currentPlayerName) ")
                                                .foregroundColor(Color(currentPlayerColor))
                                            Text("is-in-rmit-world-tour")
                                        }
                                        .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                        .padding(.bottom, 6)
                                        Text("can-move-extra-steps-this-turn")
                                            .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                            .padding(.bottom, 6)
                                        HStack (alignment: .top, spacing: 0) {
                                            Text("chosen-steps-max-17")
                                            Text(": \(stepsGranted)")
                                        }
                                        .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                        .frame(width: 210, height: 16)
                                        .padding(.bottom, 6)
                                        
                                        if currentGamePlayerId == 1 {
                                            HStack {
                                                Button {
                                                    stepsGranted <= 16 ? stepsGranted += 1 : nil
                                                } label: {
                                                    Image(systemName: "plus.circle.fill")
                                                }
                                                Button {
                                                    stepsGranted >= 1 ? stepsGranted -= 1 : nil
                                                } label: {
                                                    Image(systemName: "minus.circle.fill")
                                                }
                                            }
                                            .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                            .foregroundColor(Color(currentPlayerColor))
                                            .padding(.bottom, 4)
                                            
                                            Button {
                                                wentToTourTileMessage = false
                                                if 27 + stepsGranted >= 36 {
                                                    moveForwardBySteps(steps: stepsGranted, player: &players.players[currentGamePlayerId-1])
                                                    currentGamePlayerId == 1 ? game.game.score += 10*stepsGranted : nil
                                                    currentGamePlayerId == 1 ? game.game.score += 200 : nil
                                                    
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
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
                                                    
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
                                                        withAnimation(.linear(duration: 0.3)){
                                                            crossingStartTileMessage = false
                                                        }
                                                    }
                                                    
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                                                        playerTileActions()
                                                    }
                                                }
                                                else {
                                                    moveForwardBySteps(steps: stepsGranted, player: &players.players[currentGamePlayerId-1])
                                                    currentGamePlayerId == 1 ? game.game.score += 10*stepsGranted : nil
                                                    playerTileActions()
                                                }
                                                
                                            } label: {
                                                Text("done")
                                                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                                    .foregroundColor(.red)
                                            }
                                        }
                                        else {
                                            Text("done")
                                                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                                .foregroundColor(.red)
                                                .onAppear {
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                        stepsGranted = Int.random(in: 0...17)
                                                    }
                                                    
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.7) {
                                                        wentToTourTileMessage = false
                                                        
                                                        if 27 + stepsGranted >= 36 {
                                                            moveForwardBySteps(steps: stepsGranted, player: &players.players[currentGamePlayerId-1])
                                                            
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
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
                                                            
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.7) {
                                                                withAnimation(.linear(duration: 0.3)){
                                                                    crossingStartTileMessage = false
                                                                }
                                                            }
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                                                playerTileActions()
                                                            }
                                                        }
                                                        else {
                                                            moveForwardBySteps(steps: stepsGranted, player: &players.players[currentGamePlayerId-1])
                                                            playerTileActions()
                                                        }
                                                    }
                                                }
                                        }
                                    }
                                    .animation(.linear(duration: 0.3), value: wentToTourTileMessage)
                                }
                                .padding(.horizontal, 4)
                                .offset(y: -20)
                                
                            }
                            
                            Image(systemName: "airplane")
                                .rotation3DEffect(.degrees(isCrownAnimating ? 360 : 0), axis: (x: 1, y: 0, z: 0))
                                .rotationEffect(Angle(degrees: 135))
                                .font(.system(size: 10))
                                .foregroundColor(.blue)
                                .offset(x: 135, y: -150)
                                .animation(.linear(duration: 1.5), value: isCrownAnimating)
                        }
                    }
                    
                        /// BANKRUPTCY & WIN/LOSE MESSAGE VIEW
                    ZStack {
                            /// BANKCRUPT MESSAGE VIEW
                        ZStack {
                            if bankruptMessage {
                                ZStack {
                                    Rectangle()
                                        .fill(Color("BabyWhite"))
                                        .frame(width: 220, height: 80)
                                        .border(.black, width: 0.7)
                                    
                                    VStack (spacing: 4) {
                                        HStack (spacing: 0) {
                                            Text("\(bankruptPlayerName) ")
                                                .foregroundColor(Color(bankruptPlayerColor))
                                            Text("has-declared-bankruptcy")
                                        }
                                        HStack (spacing: 0) {
                                            Text("we-never-see")
                                            Text(" \(bankruptPlayerName) ")
                                                .foregroundColor(Color(bankruptPlayerColor))
                                            Text("again")
                                        }
                                    }
                                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                    
                                }
                                .animation(.linear(duration: 0.3), value: bankruptMessage)
                            }
                        }
                        .offset(y: -20)
                        .zIndex(100)
                        
                            /// WIN MESSAGE
                        ZStack {
                            if gameWin {
                                    // Blurred background
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(width: UIScreen.main.bounds.width*2, height: UIScreen.main.bounds.height*2)
                                    .opacity(0.4)
                                    .zIndex(99)

                                ZStack {
                                    Rectangle()
                                        .fill(Color("BabyWhite"))
                                        .frame(width: 220, height: 80)
                                        .border(.black, width: 0.7)
                                    
                                    VStack (spacing: 4) {
                                        Text("you-win-congrats")
                                            .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                        Button {
                                            resetGame()
                                            gameWin = false
                                        } label: {
                                            Text("click-here-to-continue")
                                                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                        }
                                    }
                                }
                            }
                        }
                        .offset(y: -20)
                        .zIndex(99)
                        
                            /// LOST MESSAGE
                        ZStack {
                            if gameOver {
                                    // Blurred background
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(width: UIScreen.main.bounds.width*2, height: UIScreen.main.bounds.height*2)
                                    .opacity(0.4)
                                    .zIndex(99)

                                
                                ZStack {
                                    Rectangle()
                                        .fill(Color("BabyWhite"))
                                        .frame(width: 220, height: 80)
                                        .border(.black, width: 0.7)
                                    
                                    VStack (spacing: 4) {
                                        Text("you-lost-nice-try")
                                            .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                        Button {
                                            resetGame()
                                            gameOver = false
                                            
                                        } label: {
                                            Text("click-here-to-continue")
                                                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                        }
                                    }
                                }
                            }
                        }
                        .offset(y: -20)
                        .zIndex(99)
                    }
                }
                .frame(width: 210, height: 210)
                .offset(y: -235)
                .zIndex(3)
                
                    /// BOARD VIEW
                VStack (spacing: 0) {
                        /// TOP BANNER
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
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            resetPlayerTimer(newTime: turnTimeNPC)
                                            startPlayerTimer(playerId: 2)
                                        }
                                    }
                                }
                            
                            ZStack {
                                Image(systemName: "pawprint.fill")
                                    .offset(x: player2Tile.posX + 8, y: player2Tile.posY - 8)
                                    .font(.system(size: 10))
                                    .foregroundColor(Color(players.players[1].color.rawValue))
                                    .opacity(players.players[1].money >= 0 ? 1 : 0)
                            }
                            .onChange(of: player2Turn) { turn in
                                /// player 2 - start turn
                                if turn  {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        turnPlayedByPLayer()
                                    }
                                } else {
                                    /// player 3 - start turn
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        resetPlayerTimer(newTime: turnTimeNPC)
                                        startPlayerTimer(playerId: 3)
                                    }
                                }
                            }
                            
                            ZStack {
                                Image(systemName: "pawprint.fill")
                                    .offset(x: player3Tile.posX + 8, y: player3Tile.posY + 8)
                                    .font(.system(size: 10))
                                    .foregroundColor(Color(players.players[2].color.rawValue))
                                    .opacity(players.players[2].money >= 0 ? 1 : 0)
                            }
                            .onChange(of: player3Turn) { turn in
                                /// player 3 - start turn
                                if turn  {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        turnPlayedByPLayer()
                                    }
                                } else {
                                    /// player 4 - start turn
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        resetPlayerTimer(newTime: turnTimeNPC)
                                        startPlayerTimer(playerId: 4)
                                    }
                                }
                            }

                            ZStack {
                                Image(systemName: "pawprint.fill")
                                    .offset(x: player4Tile.posX - 8, y: player4Tile.posY + 8)
                                    .font(.system(size: 10))
                                    .foregroundColor(Color(players.players[3].color.rawValue))
                                    .opacity(players.players[3].money >= 0 ? 1 : 0)
                            }
                            .onChange(of: player4Turn) { turn in
                                if turn  {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        turnPlayedByPLayer()
                                    }
                                }
                            }
                        }.zIndex(90)
                        
                            /// GAME TILE VIEWS
                        ZStack {
                            BottomTileView(cities: cities, beaches: beaches, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                            
                            LeftTileView(cities: cities, beaches: beaches, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                            
                            TopTileView(cities: cities, beaches: beaches, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                            
                            RightTileView(cities: cities, beaches: beaches, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
                            
                            Spacer()
                                .frame(width: 240, height: 240)
                                .border(.black, width: 0.3)
                            Spacer()
                                .frame(width: 361.4, height: 361.4)
                                .border(.black, width: 1.4)
                        }
                        .frame(width: 360, height: 360)
                        .background(Color("MonopolyBackground"))
                        .zIndex(-99)
                    }
                    
                        /// MIDDLE BANNER
                    ZStack {
                        HStack(spacing: 12) {
                            VStack (spacing: 8) {
                                    /// PLAYER 1 VIEW
                                ZStack {
                                    HStack (spacing: 10) {
                                            /// PLAYER NAME AND MONEY VIEW
                                        PlayerNameMoneyView(players: players, playerId: 0)
                                        ZStack {
                                            if player1Turn {
                                                Circle()
                                                    .trim(from: 0, to: CGFloat(timeLeft/60))
                                                    .stroke(Color(currentPlayerColor).opacity(0.6),  lineWidth: 3)
                                                    .frame(width: 43)
                                                    .rotationEffect(.degrees(-90))
                                                    .shadow(color: Color(currentPlayerColor), radius: 2)
                                            }
                                            else {
                                                Circle()
                                                    .stroke(Color(.white).opacity(0.6),  lineWidth: 3)
                                                    .frame(width: 43)
                                                    .shadow(color: Color(.white), radius: 2)
                                            }
                                            
                                            Image ("profile1")
                                                .resizable()
                                                .background(.red.opacity(0.4))
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                                        }
                                    }
                                }
                                .frame(width: 140, height: 55)
                                .background(player1Turn ? Color("LavenderBlush") : .gray.opacity(0.2))
                                .cornerRadius(8)
                                
                                    /// PLAYER 2 VIEW
                                ZStack {
                                    HStack (spacing: 10) {
                                            /// PLAYER NAME AND MONEY VIEW
                                        PlayerNameMoneyView(players: players, playerId: 1)
                                        ZStack {
                                            if player2Turn {
                                                Circle()
                                                    .trim(from: 0, to: CGFloat(timeLeft/turnTimeNPC))
                                                    .stroke(Color(currentPlayerColor).opacity(0.6),  lineWidth: 3)
                                                    .frame(width: 43)
                                                    .rotationEffect(.degrees(-90))
                                                    .shadow(color: Color(currentPlayerColor), radius: 2)
                                            }
                                            else {
                                                Circle()
                                                    .stroke(Color(.white).opacity(0.6),  lineWidth: 3)
                                                    .frame(width: 43)
                                                    .shadow(color: Color(.white), radius: 2)
                                            }
                                            
                                            Image ("profile2")
                                                .resizable()
                                                .background(.red.opacity(0.4))
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                                        }
                                    }
                                }
                                .frame(width: 140, height: 55)
                                .background(player2Turn ? Color("LavenderBlush") : .gray.opacity(0.2))
                                .cornerRadius(8)
                                .opacity(players.players[1].money >= 0 ? 1 : 0)

                            }
                            .padding(.horizontal, 2)
                            
                                /// DICE BUTTON VIEW
                            ZStack {
                                Button  {
                                        /// TURN START with Player 1 move first
                                    endTurn = false
                                    game.game.turn += 1
                                    resetPlayerTimer(newTime: 60)
                                    startPlayerTimer(playerId: 1)
                                    player1Turn = true
                                    checkAchievement(comparedValue: game.game.turn, comparedTag: "turn-1")
                                    checkAchievement(comparedValue: game.game.turn, comparedTag: "turn-2")
                                    
                                } label: {
                                    VStack {
                                        Image("dice\(dice1)")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .cornerRadius(9)
                                        
                                        Image("dice\(dice2)")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .cornerRadius(9)
                                    }
                                }
                                .disabled(!diceAvaialble)
                            }
                            
                            VStack (spacing: 8) {
                                    /// PLAYER 3 VIEW
                                ZStack {
                                    HStack (spacing: 10) {
                                            /// PLAYER NAME AND MONEY VIEW
                                        PlayerNameMoneyView(players: players, playerId: 2)
                                        ZStack {
                                            if player3Turn {
                                                Circle()
                                                    .trim(from: 0, to: CGFloat(timeLeft/turnTimeNPC))
                                                    .stroke(Color(currentPlayerColor).opacity(0.6),  lineWidth: 3)
                                                    .frame(width: 43)
                                                    .rotationEffect(.degrees(-90))
                                                    .shadow(color: Color(currentPlayerColor), radius: 2)
                                            }
                                            else {
                                                Circle()
                                                    .stroke(Color(.white).opacity(0.6),  lineWidth: 3)
                                                    .frame(width: 43)
                                                    .shadow(color: Color(.white), radius: 2)
                                            }
                                            
                                            Image ("profile3")
                                                .resizable()
                                                .background(.red.opacity(0.4))
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                                        }
                                    }
                                }
                                .frame(width: 140, height: 55)
                                .background(player3Turn ? Color("LavenderBlush") : .gray.opacity(0.2))
                                .cornerRadius(8)
                                .opacity(players.players[2].money >= 0 ? 1 : 0)

                                
                                    /// PLAYER 4 VIEW
                                ZStack {
                                    HStack (spacing: 10) {
                                            /// PLAYER NAME AND MONEY VIEW
                                        PlayerNameMoneyView(players: players, playerId: 3)
                                        ZStack {
                                            if player4Turn {
                                                Circle()
                                                    .trim(from: 0, to: CGFloat(timeLeft/turnTimeNPC))
                                                    .stroke(Color(currentPlayerColor).opacity(0.6),  lineWidth: 3)
                                                    .frame(width: 43)
                                                    .rotationEffect(.degrees(-90))
                                                    .shadow(color: Color(currentPlayerColor), radius: 2)
                                            }
                                            else {
                                                Circle()
                                                    .stroke(Color(.white).opacity(0.6),  lineWidth: 3)
                                                    .frame(width: 43)
                                                    .shadow(color: Color(.white), radius: 2)
                                            }
                                            Image ("profile4")
                                                .resizable()
                                                .background(.red.opacity(0.4))
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                                        }
                                    }
                                }
                                .frame(width: 140, height: 55)
                                .background(player4Turn ? Color("LavenderBlush") : .gray.opacity(0.2))
                                .cornerRadius(8)
                                .opacity(players.players[3].money >= 0 ? 1 : 0)

                            }
                            .padding(.horizontal, 2)
                        }
                        .padding(.vertical, 4)
                    }
                    .frame(width: 361.4, height: 130)
                    .background(Color("BabyWhite"))
                    .border(.black.opacity(0.8), width: 1.4)
                    .padding(.top, -0.7)
                    
                    Spacer()
                }
            }
            .offset(y: 74.5)
            
                /// GAME PROGRESS VIEW
            ZStack {
                VStack {
                    List {
                        ForEach(players.players, id: \.id) { player in
                            playerRow(player: player)
                                .listRowBackground(Color("BabyWhite"))
                        }
                    }
                    .frame(width: 361.5, height: 240)
                    .listStyle(.plain)
                }
            }
            .offset(y: 260)
            .zIndex(50)
        
        }
        .frame(width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height)
        .background(Color("BabyWhite"))
        .onChange(of: endTurn) { newTurn in
            game.game.cities = cities.cities
            game.game.achievements = achievements.achievements
            game.game.beaches = beaches.beaches
            game.game.players = players.players
            saveGame()
            saveGames()
        }
        .onAppear {
            loadGame()
            print(game.games)
            players.players[0].name = game.game.username
            game.game.turn == 0 ? players.players[0].money = game.game.startingMoney : nil
            players.players = game.game.players
            cities.cities = game.game.cities
            beaches.beaches = game.game.beaches
            achievements.achievements = game.game.achievements
            
            player1Tile = tiles[game.game.players[0].tilePositionId]
            player2Tile = tiles[game.game.players[1].tilePositionId]
            game.game.players.count >= 3 ? player3Tile = tiles[game.game.players[2].tilePositionId] : nil
            game.game.players.count == 4 ? player4Tile = tiles[game.game.players[3].tilePositionId] : nil
        }
        .environment(\.locale, Locale.init(identifier: game.game.language))
//        .environment(\.colorScheme, game.game.darkModeEnabled ? .dark : .light)
    }
    
    @ViewBuilder
    private func playerRow(player: Player) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(player.name)
                Text("$\(player.money)")
                    .foregroundColor(player.money >= 0 ? .green : .red)
            }
                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                .padding(.bottom, 2)

            
            ForEach(player.tilePropertyIds, id: \.self) { tileId in
                propertyRow(tileId: tileId)
            }
        }
    }
    
    @ViewBuilder
    private func propertyRow(tileId: Int) -> some View {
        if let tile = tiles.first(where: { $0.id == tileId }) {
            switch tile.type {
            case .city:
                if let city = cities.cities.first(where: { $0.tileId == tileId }) {
                    HStack (spacing: 0) {
                        Text("city")
                        Text(": \(city.cityName), ")
                        Text("level")
                        Text(": \(city.currentLevel), ")
                        Text("rent")
                        Text(": \(city.rent)")

                    }
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .foregroundColor(.blue)
                }
            case .beach:
                if let beach = beaches.beaches.first(where: { $0.tileId == tileId }) {
                    HStack (spacing: 0) {
                        Text("beach")
                        Text(": \(beach.beachName), ")
                        Text("level")
                        Text(": \(beach.currentLevel), ")
                        Text("rent")
                        Text(": \(beach.rent)")

                    }
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .foregroundColor(.orange)
                }
            default:
                Text("Other type of property")
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
                }
                else {
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
                endTurn = true
            default:
                break
        }
    }
    
    func playerCityTileAction() {
        print("playerCityTileAction invoked() by Player \(currentGamePlayerId),", terminator: " ")
        cities.updateCityBuyingOption(player: players.players[currentGamePlayerId-1], options: &cityBuyingOption)
        
        if let index = cities.cities.firstIndex(where: {$0.tileId == players.players[currentGamePlayerId-1].tilePositionId}) {
            print("in city: \(cities.cities[index].id)", terminator: " ")
            if cities.cities[index].ownerId != -1 && cities.cities[index].ownerId != currentGamePlayerId {
                players.players[currentGamePlayerId-1].money -= cities.cities[index].rent
                players.players[cities.cities[index].ownerId-1].money += cities.cities[index].rent
                
                paidPropertyOwnerId = cities.cities[index].ownerId
                rentMoneyPaid = cities.cities[index].rent
                checkAchievement(comparedValue: rentMoneyPaid, comparedTag: "rent-paid-1")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                    rentPaidMessage = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.7) {
                    rentPaidMessage = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                    rentMoneyPaid = 0
                    checkWinning()
                }

                print("Player \(currentGamePlayerId) paid \(cities.cities[index].rent) to Player  \(players.players[cities.cities[index].ownerId-1].id)")
            }
            else {
                cities.cities[index].printCityBasicInfo()
                if currentGamePlayerId == 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                        buyingPropertyMessage = true
                    }
                }
                else {
                    buyingPropertyMessage = false
                    if cities.buyCityAutomatically(player: &players.players[currentGamePlayerId-1], totalBuyingCost: &totalBuyingCost) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                            cityBoughtMessage = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
                            cityBoughtMessage = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                            totalBuyingCost = 0
                        }
                    }
                    else {
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
    
    func playerBeachTileAction() {
        print("pLayerBeachTileAction invoked() by Player \(currentGamePlayerId),", terminator: " ")
        
        if let index = beaches.beaches.firstIndex(where: {$0.tileId == players.players[currentGamePlayerId-1].tilePositionId}) {
            print("in beach: \(beaches.beaches[index].id)", terminator: " ")
            
            if beaches.beaches[index].ownerId != -1 && beaches.beaches[index].ownerId != currentGamePlayerId {
                players.players[currentGamePlayerId-1].money -= beaches.beaches[index].rent
                players.players[beaches.beaches[index].ownerId-1].money += beaches.beaches[index].rent
                
                paidPropertyOwnerId = beaches.beaches[index].ownerId
                rentMoneyPaid = beaches.beaches[index].rent
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                    rentPaidMessage = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
                    rentPaidMessage = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                    rentMoneyPaid = 0
                    checkWinning()
                }
                
                print("Player \(currentGamePlayerId) paid \(beaches.beaches[index].rent) to Player  \(players.players[beaches.beaches[index].ownerId-1].id)")
            }
            else {
                beaches.beaches[index].printBeachBasicInfo()
                if currentGamePlayerId == 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                        buyingPropertyMessage = true
                    }
                }
                else {
                    buyingPropertyMessage = false
                    if beaches.buyBeach(player: &players.players[currentGamePlayerId-1]) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                            beachBoughtMessage = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
                            beachBoughtMessage = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                            totalBuyingCost = 0
                        }
                    }
                    else {
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
    
    func playerTaxTileAction() {
        print("pLayerTaxTileAction invoked() by Player \(currentGamePlayerId),", terminator: " ")
        let tax = Int.random(in: 5...15)

        if !isChampionEmpty && championPlayerId == currentGamePlayerId {
            taxMoneyPaid = players.players[currentGamePlayerId-1].money*tax/100 * (100-championMultiplier)/100
            print("Player(Champion) \(currentGamePlayerId) paid \(taxMoneyPaid) as Tax")
            players.players[currentGamePlayerId-1].money -= taxMoneyPaid
        } else {
            taxMoneyPaid = players.players[currentGamePlayerId-1].money*tax/100
            print("Player \(currentGamePlayerId) paid \(taxMoneyPaid) as Tax")
            players.players[currentGamePlayerId-1].money -= taxMoneyPaid
        }
        checkAchievement(comparedValue: taxMoneyPaid, comparedTag: "tax-paid-1")

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
            taxPaidMessage = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
            taxPaidMessage = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            taxMoneyPaid = 0
        }
        
        print("Player \(currentGamePlayerId) paid tax with \(taxMoneyPaid)")
    }
    
    func playerMoneyTileAction() {
        print("pLayerTaxTileAction invoked() by Player \(currentGamePlayerId),", terminator: " ")
        moneyReceived = Int.random(in: 100...200)
        
        if !isChampionEmpty && championPlayerId == currentGamePlayerId {
            print("Player \(currentGamePlayerId) received \(moneyReceived) as Free Reward")
            players.players[currentGamePlayerId-1].money += moneyReceived
        } else {
            moneyReceived = moneyReceived * (100+championMultiplier)/100
            print("Player(Champion) \(currentGamePlayerId) received \(moneyReceived) as Free Reward")
            players.players[currentGamePlayerId-1].money += moneyReceived
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
            moneyReceivedMessage = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.6) {
            moneyReceivedMessage = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            moneyReceived = 0
        }
        
        print("Player \(currentGamePlayerId) receive money of \(moneyReceived)")
    }

    func playerTileActions() {
        if (tiles[players.players[currentGamePlayerId-1].tilePositionId].type == .city) {
            playerCityTileAction()
            currentGamePlayerId == 1 ? game.game.score += 50 : nil
        }
        else if (tiles[players.players[currentGamePlayerId-1].tilePositionId].type == .beach) {
            playerBeachTileAction()
            currentGamePlayerId == 1 ? game.game.score += 50 : nil
        }
        else if (tiles[players.players[currentGamePlayerId-1].tilePositionId].type == .tax) {
            playerTaxTileAction()
            currentGamePlayerId == 1 ? game.game.score += 50 : nil
        }
        else if (tiles[players.players[currentGamePlayerId-1].tilePositionId].type == .money) {
            playerMoneyTileAction()
            currentGamePlayerId == 1 ? game.game.score += 50 : nil
        }
        else if (tiles[players.players[currentGamePlayerId-1].tilePositionId].type == .island) {
            if !isChampionEmpty && championPlayerId == currentGamePlayerId {
                print("Player(Champion) \(currentGamePlayerId) is not added to lockedPLayerIds in turn \(game.game.turn)")
            }
            else {
                lockedPLayerIds.append(currentGamePlayerId)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                    wentToIslandTileMessage = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
                    wentToIslandTileMessage = false
                }
                lockedinTurn = game.game.turn
                print("Player \(currentGamePlayerId) is added to lockedPLayerIds in turn \(game.game.turn)")
                currentGamePlayerId == 1 ? game.game.score += 100 : nil
            }
        }
        else if (tiles[players.players[currentGamePlayerId-1].tilePositionId].type == .champion) {
            championPlayerId = currentGamePlayerId
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                wentToChampionTileMessage = true
                isChampionEmpty = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
                wentToChampionTileMessage = false
            }
            print("Player \(currentGamePlayerId) is RMIT new Champion")
            currentGamePlayerId == 1 ? game.game.score += 100 : nil

        }
        else if (tiles[players.players[currentGamePlayerId-1].tilePositionId].type == .tour) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                wentToTourTileMessage = true
            }
            print("Player \(currentGamePlayerId) went to RMIT World Tour")
            currentGamePlayerId == 1 ? game.game.score += 100 : nil
        }
    }
    
    func turnPlayedByPLayer() {
        if players.players[currentGamePlayerId-1].money >= 0 {
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
            
            if lockedPLayerIds.contains(currentGamePlayerId) { // in prison
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if tileIdBefore <= 34 && tileIdAfter >= 36 {
                        moveForwardBySteps(steps: totalDice, player: &players.players[currentGamePlayerId-1])
                        currentGamePlayerId == 1 ? game.game.score += 10*totalDice : nil
                        currentGamePlayerId == 1 ? game.game.score += 200 : nil
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            playerTileActions()
                        }
                    }
                    else {
                        moveForwardBySteps(steps: totalDice, player: &players.players[currentGamePlayerId-1])
                        game.game.score += 10*totalDice
                        playerTileActions()
                    }
                }
            }
            
            checkAchievement(comparedValue: players.players[0].money, comparedTag: "income-1")
            checkWinning()
        }
        else {
            
        }
    }
    
    func checkWinning() {
        if currentPlayerMoney < 0 {
            if currentGamePlayerId == 1 {
                gameOver = true
            }
            else {
                bankruptPlayerName = currentPlayerName
                bankruptPlayerColor = currentPlayerColor
                bankruptMessage = true
                championPlayerId == currentGamePlayerId ? championPlayerId = -1 : nil
                isChampionEmpty = true
                beaches.beaches = beaches.beaches.map {
                    var beach = $0
                    if beach.ownerId == currentGamePlayerId {
                        beach.ownerId = -1
                        beach.currentLevel = 0
                    }
                    return beach
                }
                cities.cities = cities.cities.map {
                    var city = $0
                    if city.ownerId == currentGamePlayerId {
                        city.ownerId = -1
                        city.currentLevel = 0
                    }
                    return city
                }
                players.players[currentGamePlayerId-1].tilePropertyIds.removeAll()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    bankruptMessage = false
                }
            }
        }
        
        let count = players.players.filter { $0.money < 0 }.count
        print("count: \(count)")
        if count == 3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                gameWin = true
            }
        }
    
    }
    
    func checkAchievement(comparedValue: Int, comparedTag: String) {
        for achievement in achievements.achievements {
            let id = achievement.id
            if !achievement.completed {
                if achievement.tag == comparedTag {
                    if comparedValue >= achievement.tagVar {
                        achievements.achievements[id].completed = true
                        game.game.achievements[id].completed = true
                        latestAchievement = game.game.achievements[id]
                        newAchievement = true
                    
                    }
                    
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    newAchievement = false
                }
            }
        }

    }
    
    func saveGame() {
        do {
            let encoded = try JSONEncoder().encode(game.game)
            gameData = encoded
            print("[game saved]", terminator: ", ")

        } catch {
            print("Error saving game")
        }
    }
    
    func loadGame() {
        do {
            let decoded = try JSONDecoder().decode(Game.self, from: gameData)
            self.game.game = decoded
            print("[game loaded]", terminator: ", ")
        } catch {
            print("Error loading game")
        }
    }
    
    func saveGames() {
        do {
            let encoded = try JSONEncoder().encode(game.games)
            gamesData = encoded
            print("[game saved]", terminator: ", ")

        } catch {
            print("Error saving game")
        }
    }
    
    func loadGames() {
        do {
            let decoded = try JSONDecoder().decode([Game].self, from: gamesData)
            self.game.games = decoded
            print("[game loaded]", terminator: ", ")
        } catch {
            print("Error loading game")
        }
    }
    
    func resetGame() {
        let username = game.game.username
        game.addGame(game: game.game)
        game.game = defaultGame
        game.game.username = username
        saveGame()
        saveGames()
        gameOver = false
        gameWin = false
        endTurn = false
        loadGame()
        cities.cities = game.game.cities
        beaches.beaches = game.game.beaches
        players.players = game.game.players
        achievements.achievements = game.game.achievements
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(isPresented: .constant(true))
    }
}
