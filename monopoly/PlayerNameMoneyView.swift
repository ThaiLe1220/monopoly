//
//  PlayerName&MoneyView.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct PlayerNameMoneyView: View {
    @ObservedObject var players:PlayerModel
    var playerId: Int
    
    var body: some View {
            // PLAYER NAME AND MONEY VIEW
        VStack {
            Text(players.players[playerId].name)
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
                .frame(width: 70, height: 20)
                .background(Color(players.players[playerId].color.rawValue))
                .cornerRadius(8)
                .offset(y: -4)
            
            Text("$\(players.players[playerId].money)")
                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                .foregroundColor(Color.green.opacity(0.9))
                .frame(height: 6)
            
        }

    }
}

struct PlayerNameMoneyView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerNameMoneyView(players: PlayerModel(), playerId: 0)
    }
}
