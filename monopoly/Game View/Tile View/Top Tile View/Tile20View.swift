
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

struct Tile20View: View {
    @ObservedObject var beaches:BeachModel
    @ObservedObject var players:PlayerModel
    
    @Binding var showTileDetailedInfo: Bool
    @Binding var selectedTileId: Int
    
    var body: some View {
        ZStack {
            ZStack{
                BeachTileView(beaches: beaches, players: players, showTileDetailedInfo: $showTileDetailedInfo, selectedTileId: $selectedTileId, beachId: 3)
            }
            .frame(width: 30, height: 60)
            .background(.brown.opacity(0.05))
            .offset(x: 75, y: 150)
        }
    }
}

struct Tile20View_Previews: PreviewProvider {
    static var previews: some View {
        Tile20View(beaches: BeachModel(), players: PlayerModel(), showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1))
    }
}
