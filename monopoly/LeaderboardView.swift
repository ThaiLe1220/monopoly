//
//  PLayerInfoView.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct LeaderboardView: View {
    @AppStorage("games") private var gamesData: Data = Data()
    @AppStorage("game") private var gameData: Data = Data()

    @StateObject var game = GameModel()
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            List {
                ForEach(game.games.sorted(by: { $0.score > $1.score })) { game in
                    VStack(alignment: .leading) {
                        HStack {
                            Text("username")
                            Text(" \(game.username)")
                        }
                        HStack {
                            Text("difficulty")
                            Text(" \(game.difficulty)")
                        }
                        HStack {
                            Text("score")
                            Text(" \(game.score)")
                        }
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(game.achievements.filter { $0.completed }) { achievement in
                                    VStack (spacing: 2) {
                                        Image("badge\(achievement.id)")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                        Text(achievement.title)
                                            .font(.headline)
                                    }
                                    .padding(8)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Leaderboard")

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
                loadGames()
                loadGame()
            }
            .environment(\.locale, Locale.init(identifier: game.game.language))
            .environment(\.colorScheme, game.game.darkModeEnabled ? .dark : .light)
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


struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView(isPresented: .constant(true))
    }
}
