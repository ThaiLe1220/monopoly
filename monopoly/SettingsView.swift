
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

struct SettingsView: View {
    @AppStorage("game") private var gameData: Data = Data()
    @AppStorage("games") private var gamesData: Data = Data()

    @StateObject var game = GameModel()
    
    @State private var isSaveAlertPresented = false
    @State private var isRestoreAlertPresented = false

    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("user-detail")) {
                    TextField("username", text: $game.game.username)
                        .onChange(of: game.game.username) { _ in
                            game.game.adjusted = true
                        }
                }

                Section (header: Text("game")) {
                    if game.game.turn > 0 {
                        HStack {
                            Text("difficulty")
                            Spacer()
                            if game.game.difficulty == -1 {Text("easy")}
                            if game.game.difficulty == 0 {Text("normal")}
                            if game.game.difficulty == 1 {Text("hard")}
                        }
                    }
                    else {
                        Picker("difficulty", selection: $game.game.difficulty) {
                            Text("easy").tag(-1)
                            Text("normal").tag(0)
                            Text("hard").tag(1)
                        }
                        .onChange(of: game.game.difficulty) { _ in
                            game.game.adjusted = true
                        }
                    }

                    Picker("language", selection: $game.game.language) {
                        Text("English").tag("en")
                        Text("Tiếng Việt").tag("vi")
                    }
                    .onChange(of: game.game.language) { _ in
                        game.game.adjusted = true
                    }
                    
                    Toggle("dark-mode", isOn: $game.game.darkModeEnabled)
                        .onChange(of: game.game.darkModeEnabled) { _ in
                            game.game.adjusted = true
                        }
                    
                }

                Section (header: Text("utility")){
                    Button(action: {
                        isSaveAlertPresented = true
                    }) {
                        Text("save-change")
                            .foregroundColor(.blue)
                    }
                    .alert(isPresented: $isSaveAlertPresented) {
                            Alert(
                                title: Text("save-change"),
                                message: Text("save-change-message"),
                                primaryButton: .default(Text("yes")) {
                                    saveUserName()
                                    saveStartingMoney()
                                    saveGame()
                                    loadGame()
                                },
                                secondaryButton: .cancel()
                            )
                        }

                    Button(action: {
                        isRestoreAlertPresented = true
                    }) {
                        Text("restore-default")
                            .foregroundColor(.orange)
                    }
                    .alert(isPresented: $isRestoreAlertPresented) {
                        Alert(
                            title: Text("restore-default"),
                            message: Text("restore-default-message"),
                            primaryButton: .default(Text("yes")) {
                                restoreDefaults()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
            .navigationBarItems(leading: VStack{
                    Button(action: {
                            isPresented.toggle()
                        }) {
                            Image(systemName: "arrowshape.turn.up.forward.fill")
                                .resizable()
                                .rotation3DEffect(Angle(degrees: 180), axis: (x: 0, y: 1, z: 0))
                                .frame(width: 20, height: 15)
                                .foregroundColor(game.game.darkModeEnabled ? .white : .black)
                    }
                    .padding(8)
  
            })
            .onAppear {
                loadGame()
            }
            .onDisappear {
                saveDifficulty()
                saveUserName()
                saveStartingMoney()
                saveGame()
            }
            .environment(\.locale, Locale.init(identifier: game.game.language))
            .environment(\.colorScheme, game.game.darkModeEnabled ? .dark : .light)
        }
    }
    
    func saveDifficulty() {
        if game.game.difficulty == -1 {
            game.game.startingMoney = 2000
        } else if game.game.difficulty == 0 {
            game.game.startingMoney = 1000
        } else if game.game.difficulty == 1 {
            game.game.startingMoney = 500
        }

    }
    
    func saveUserName() {
        game.game.players[0].name = game.game.username
        game.game.adjusted = true

    }

    func saveStartingMoney() {
        for i in 0...3 {
            game.game.players[i].money = game.game.startingMoney
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
    
    func restoreDefaults() {
        game.game = Game(id: -1, username: "", startingMoney: 1000, language: "en", darkModeEnabled: false, turn: 0, players: PlayerModel().players, cities: CityModel().cities, beaches: BeachModel().beaches, achievements: AchievementModel().achievements, adjusted: false, difficulty: 0, score: 0)
        
        saveGame()
        print("[game data restored to default]", terminator: ", ")
    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isPresented: .constant(true))
    }
}
