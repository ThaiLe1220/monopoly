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
                Section(header: Text("user-detail")) {
                    TextField("username", text: $game.game.username)
                }

                Section (header: Text("game")) {
                    HStack {
                        Text("starting-money")
                        Spacer()
                        TextField("amount", value: $game.game.startingMoney, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                    Picker("language", selection: $game.game.language) {
                        Text("English").tag("en")
                        Text("Tiếng Việt").tag("vi")
                    }
                    Toggle("dark-mode", isOn: $game.game.darkModeEnabled)
                }

                Section (header: Text("utilities")){
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
            .environment(\.locale, Locale.init(identifier: game.game.language))

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
