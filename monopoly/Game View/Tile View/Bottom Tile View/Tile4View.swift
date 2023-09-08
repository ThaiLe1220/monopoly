
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

struct Tile4View: View {
    @ObservedObject var players:PlayerModel
    @Binding var showTileDetailedInfo: Bool
    @Binding var selectedTileId: Int
    
    var body: some View {
        ZStack {
            ZStack{
                TaxTileView(players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId)
            }
            .frame(width: 30, height: 60)
            .offset(x: 15, y: 150)
        }
    }
}

struct Tile4View_Previews: PreviewProvider {
    static var previews: some View {
        Tile4View(players: PlayerModel(), showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1))
    }
}
