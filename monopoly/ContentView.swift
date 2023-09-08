
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

struct ContentView: View {
    @AppStorage("game") private var gameData: Data = Data()

    @State private var showMenu = false
    @State private var name: String = ""
    @StateObject var game: GameModel = GameModel() 
    @State var showAlert: Bool = false
    @State var showCustomAlert: Bool = false

    var body: some View {
        VStack {
            if game.game.turn > 0 {
                Text("Would you like to continue or start a new game?")
                    .padding()
                Button("Continue") {
                    self.showMenu = true
                }
                .padding()

                Button("New Game") {
                    game.game.turn = 0 // Reset the turn to 0
                    self.showCustomAlert = true
                }
                .padding()
            } else {
                Text("Enter your name to start the game.")
                    .padding()
                TextField("Name", text: $name)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Start Game") {
                    if !name.isEmpty {
                        game.game.username = name
                        self.showMenu = true
                    }
                }
                .padding()
                .disabled(name.isEmpty)
            }
        }
        .sheet(isPresented: $showMenu) {
            MenuView()
        }
        .sheet(isPresented: $showCustomAlert, content: {
            CustomAlertView(name: $name, showMenu: $showMenu)
        })
    }
}

struct CustomAlertView: View {
    @Binding var name: String
    @Binding var showMenu: Bool

    var body: some View {
        VStack {
            Text("Enter your name:")
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("OK") {
                if !name.isEmpty {
                    showMenu = true
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
