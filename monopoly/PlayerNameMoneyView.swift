//
//  PlayerName&MoneyView.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct PlayerNameMoneyView: View {
    @Binding var player: Player
    var body: some View {
            // PLAYER NAME AND MONEY VIEW
        VStack () {
            Text(player.name)
                .font(.system(size: 12, weight: .bold, design: .default))
                .foregroundColor(.white)
                .frame(width: 68, height: 20)
                .background(Color(player.color.rawValue))
                .cornerRadius(4)
            
            Text("$ \(player.money)")
                .font(.system(size: 12, weight: .medium, design: .default))
                .foregroundColor(Color.green.opacity(0.9))
            .frame(height: 8)
            
        }
    }
}

struct PlayerNameMoneyView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerNameMoneyView(player: .constant(player1))
    }
}
