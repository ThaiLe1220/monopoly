
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

import SwiftUI

import SwiftUI

struct MenuView: View {
    @AppStorage("game") private var gameData: Data = Data()

    @StateObject var game = GameModel()
    
    @State private var gameView = false
    @State private var leaderboardView = false
    @State private var settingsView = false
    
    var body: some View {
        ZStack {            
            // Background
            LinearGradient(gradient: Gradient(colors: [.black.opacity(0.9), Color("BabyBlue"), .blue.opacity(0.9)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            // Buttons
            VStack(spacing: 30) {
                Button(action: {
                    gameView.toggle()
                }) {
                    Text("Game")
                        .font(.system(size: 30, weight: .bold, design: .monospaced))
                        .padding(.vertical, 20)
                        .padding(.horizontal, 40)
                        .background(Color.green)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                }
                .fullScreenCover(isPresented: $gameView) {
                    GameView(isPresented: $gameView)
                }
                
                Button(action: {
                    leaderboardView.toggle()
                }) {
                    Text("Leaderboard")
                        .font(.system(size: 30, weight: .bold, design: .monospaced))
                        .padding(.vertical, 20)
                        .padding(.horizontal, 40)
                        .background(Color.red)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                }
                .fullScreenCover(isPresented: $leaderboardView) {
                    LeaderboardView(isPresented: $leaderboardView)
                }
                
                Button(action: {
                    settingsView.toggle()
                }) {
                    Text("Settings")
                        .font(.system(size: 28, weight: .bold, design: .monospaced))
                        .padding(.vertical, 20)
                        .padding(.horizontal, 40)
                        .background(Color.yellow)
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .shadow(radius: 10)
                }
                .fullScreenCover(isPresented: $settingsView) {
                    SettingsView(isPresented: $settingsView)
                }
            }
        }
        .onAppear {
            playBackground()
            Timer.scheduledTimer(withTimeInterval: 150, repeats: true) { timer in
                playBackground()
            }
            loadGame()
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
}



struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
