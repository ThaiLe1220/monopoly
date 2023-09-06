//
//  ContentView.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 05/09/2023.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("game") private var gameData: Data = Data()
    @StateObject var game = GameModel()

    @State private var selectedTab = 0
    @State private var isbackgroundPlaying: Bool = false
    @State private var showingInfo = false

    var body: some View {
        ZStack {
            TabView (selection: $selectedTab){
                /// GAME VIEW
                ZStack  {
                    HStack {
                        Spacer()
                        Button(action: {
                            showingInfo.toggle()
                        }) {
                            Image(systemName: "info.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.black.opacity(0.8))
                        }
                        .sheet(isPresented: $showingInfo) {
                            HowToPlayView()
                        }
                        .padding()
                    }
                    .frame(width: 360, height: 40)
                    .border(.black.opacity(0.8), width: 1.4)
                    .offset(y: -340)
                    .zIndex(99)
                    
                    GameView()
                        .offset(y: 40)

                }
                .background(.regularMaterial)
                .tabItem {Label("Game", systemImage: "gamecontroller.fill")}
                .tag(0)

                /// LEADERBOARD VIEW
                VStack {
                    LeaderboardView()
                }
                .tabItem {Label("Leaderboard", systemImage: "list.bullet.rectangle.portrait.fill")}
                .tag(1)

                /// ACHIEVEMENT VIEW
                VStack {
                    AchievementsView()
                }
                .tabItem {Label("Achievement", systemImage: "trophy.fill")}
                .tag(2)

                /// SETTING VIEW
                VStack  {
                   SettingsView()
                }
                .tabItem {Label("Setting", systemImage: "gearshape.2.fill")}
                .tag(3)
            }
            .onAppear {
                loadGame()

//                playBackground()
//                Timer.scheduledTimer(withTimeInterval: 150, repeats: true) { timer in
//                    self.isbackgroundPlaying.toggle()
//                }
            }
            .onChange(of: isbackgroundPlaying, perform: { _ in
//                playBackground()
            })
        }
        .background(.ultraThinMaterial)
        .environment(\.locale, Locale.init(identifier: game.game.language))
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
