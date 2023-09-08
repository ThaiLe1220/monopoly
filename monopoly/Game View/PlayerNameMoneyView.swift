
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
            
            Text("\(players.players[playerId].money)$")
                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                .foregroundColor(Color.green.opacity(0.9))
                .frame(height: 10)
            
        }

    }
}

struct PlayerNameMoneyView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerNameMoneyView(players: PlayerModel(), playerId: 0)
    }
}
