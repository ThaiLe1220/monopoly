//
//  SettingsView.swift
//  monopoly
//
//  Created by Thai, Le Hong on 05/09/2023.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("game") private var gameData: Data = Data()
      
    @StateObject var game = GameModel()
    @State private var isSaveAlertPresented = false
    @State private var isRestoreAlertPresented = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Details")) {
                    TextField("Username", text: $game.game.username)
                }

                Section (header: Text("Game")) {
                    HStack {
                        Text("Starting Money:")
                        Spacer()
                        TextField("Amount", value: $game.game.startingMoney, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    Picker("Language", selection: $game.game.language) {
                        Text("English").tag("en")
                        Text("Tiếng Việt").tag("vi")
                    }
                    Toggle("Dark Mode", isOn: $game.game.darkModeEnabled)
                }

                Section (header: Text("Utility")){
                    Button(action: {
                        isSaveAlertPresented = true
                    }) {
                        Text("Save Changes")
                            .foregroundColor(.blue)
                    }
                    .alert(isPresented: $isSaveAlertPresented) {
                            Alert(
                                title: Text("Save Changes"),
                                message: Text("Are you sure you want to save the changes?"),
                                primaryButton: .default(Text("Yes")) {
                                    saveUserName()
                                    saveStartingMoney()
                                    saveGame()
                                },
                                secondaryButton: .cancel()
                            )
                        }

                    Button(action: {
                        isRestoreAlertPresented = true
                    }) {
                        Text("Restore Default Settings")
                            .foregroundColor(.orange)
                    }
                    .alert(isPresented: $isRestoreAlertPresented) {
                        Alert(
                            title: Text("Restore Default Settings"),
                            message: Text("Are you sure you want to restore default settings?"),
                            primaryButton: .default(Text("Yes")) {
                                restoreDefaults()
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
            .navigationBarTitle("Settings")
            .onAppear {
                loadGame()

            }
            .onChange(of: game.game) { _ in
                game.game.adjusted = true
            }
            .onDisappear {
                saveUserName()
                saveStartingMoney()
                saveGame()

            }


        }
    }
    
    func saveUserName() {
        game.game.players[0].name = game.game.username
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
            print("\(game.game)")
        } catch {
            print("Error loading game")
        }
    }
    
    func restoreDefaults() {
        game.game = Game(username: "Eugene", startingMoney: 2000, language: "en", darkModeEnabled: false, turn: 0, players: PlayerModel().players, cities: CityModel().cities, beaches: BeachModel().beaches, achivements: AchievementModel().achievements, adjusted: false)
        saveGame()
        print("[game data restored to default]", terminator: ", ")
        print("\(game.game)")

    }
    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
