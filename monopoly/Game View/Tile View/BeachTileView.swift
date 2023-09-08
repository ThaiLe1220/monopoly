
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

struct BeachTileView: View {
    @ObservedObject var beaches:BeachModel
    @ObservedObject var players:PlayerModel
    
    @Binding var showTileDetailedInfo: Bool
    @Binding var selectedTileId: Int
    
    var tiles:[TilePosition] = TilePositionModel().tiles
    var beachId: Int
    
    var rotatedAngle: Double {
        if beachId > 2 {return 180} else {return 0}
    }

    var body: some View {
        ZStack {
            Text("\(beaches.beaches[beachId].beachName)")
                .font(.system(size: 8, weight: .semibold, design: .monospaced))
                .rotationEffect(Angle(degrees: rotatedAngle))
                .foregroundColor(.blue)
                .offset(y: -5)

            
            Text("\(beaches.beaches[beachId].rent)$")
                .font(.system(size: 8.5, weight: .semibold, design: .monospaced))
                .rotationEffect(Angle(degrees: rotatedAngle))
                .foregroundColor(.green)
                .offset(y: -17.5)

            ZStack {
                Image(systemName: "beach.umbrella.fill")
                    .rotationEffect(Angle(degrees: rotatedAngle))
                    .font(.system(size: 8))
                    .foregroundColor(.blue)
                    .offset(x: 6, y: 23)
                Image(systemName: "beach.umbrella.fill")
                    .rotationEffect(Angle(degrees: rotatedAngle))
                    .font(.system(size: 8))
                    .foregroundColor(.blue)
                    .offset(x: -6, y: 23)
                Image(systemName: "figure.open.water.swim")
                    .rotationEffect(Angle(degrees: rotatedAngle))
                    .font(.system(size: 10))
                    .foregroundColor(.blue)
                    .offset(x: 0, y: 11)
            }

            
            /// BORDER
            ZStack {
                Spacer()
                    .frame(width: 1.4, height: 61.4)
                    .background(.black.opacity(0.7))
                .offset(x:-15)
                Spacer()
                    .frame(width: 1.4, height: 61.4)
                    .background(.black.opacity(0.7))
                    .offset(x:15)
                Spacer()
                    .frame(width: 30, height: 1.4)
                    .background(.black.opacity(0.7))
                    .offset(y:30)
                Spacer()
                    .frame(width: 30, height: 1.4)
                    .background(.black.opacity(0.7))
                    .offset(y:-30)
            }
            
            /// OWNER IDENTIFICATION VIEW
            ZStack {
                if beaches.beaches[beachId].currentLevel < 4 {
                    ForEach(0..<beaches.beaches[beachId].currentLevel, id: \.self) { _ in
                        Image(systemName: "house.fill")
                            .frame(width: 10, height: 10)
                            .font(.system(size: 8, weight: .regular, design: .default))
                            .rotationEffect(Angle(degrees: 90 * rotatedAngle))
                            .foregroundColor(Color(players.players[beaches.beaches[beachId].ownerId-1].color.rawValue))
                    }
                }
                else {
                    Image(systemName: "building.2.fill")
                        .frame(width: 10, height: 10)
                        .font(.system(size: 8, weight: .regular, design: .default))
                        .rotationEffect(Angle(degrees: 90 * rotatedAngle))
                        .foregroundColor(Color(players.players[beaches.beaches[beachId].ownerId-1].color.rawValue))
                }
            }
            .offset(y: -35)
        }
    }
}

struct BeachTileView_Previews: PreviewProvider {
    static var previews: some View {
        BeachTileView(beaches: BeachModel(), players: PlayerModel(), showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1), beachId: 0)
    }
}
