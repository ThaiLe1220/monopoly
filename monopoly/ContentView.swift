//
//  ContentView.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 05/09/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedTab = 0

    
    var body: some View {
        GeometryReader { geometry in
            TabView (selection: $selectedTab){
                /// GAME VIEW
                ZStack  {
                    GameView()
                }
                .tabItem {Label("Game", systemImage: "gamecontroller.fill")}
                .tag(0)

                /// ACHIVEMENT VIEW
                VStack {
                    
                }
                .tabItem {Label("Leaderboard", systemImage: "list.bullet.rectangle.portrait.fill")}
                .tag(1)

                /// Search View
                VStack {
                    
                }
                .tabItem {Label("Achievement", systemImage: "trophy.fill")}
                .tag(2)

                /// Wishlist View
                NavigationStack  {
                   
                }
                .tabItem {Label("Setting", systemImage: "gearshape.2.fill")}
                .tag(3)
            }
            .overlay(
                /// overlay navbar
                HStack {
                    Spacer()

                    Button(action: {
                        withAnimation(.linear(duration: 1)) {
                            selectedTab = 1
                        }
                    }) {
                        Image(systemName: "cart.fill")
                            .font(.system(size: 22))
                            .foregroundColor(Color("DarkGold"))
                                              
                    }
                    
                    Button(action: {
                    }) {
                        Image(systemName: "moon")
                            .font(.system(size: 22))
                            .foregroundColor(Color("DarkGold"))
                    }
                }
                .padding(.horizontal, 8)
                .padding(.top, 0),
                alignment: .top
        )}
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
