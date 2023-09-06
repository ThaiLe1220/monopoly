//
//  MainView.swift
//  monopoly
//
//  Created by Thai, Le Hong on 06/09/2023.
//

import SwiftUI

import SwiftUI

struct MenuView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: GameView()) {
                    Text("PLAY")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                .padding()
                
                NavigationLink(destination: AchievementsView()) {
                    Text("ACHIEVEMENT")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                .padding()
                
                NavigationLink(destination: SettingsView()) {
                    Text("SETTING")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                .padding()
            }
        }
    }
}


struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
