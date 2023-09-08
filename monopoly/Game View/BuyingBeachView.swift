
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

struct BuyingBeachView: View {
    @Binding var buyingMessage: Bool
    @Binding var totalBuyingCost : Int
    @Binding var beachBoughtMessage: Bool

    @ObservedObject var beaches:BeachModel
    @ObservedObject var players:PlayerModel
    
    var body: some View {
        VStack (spacing: 0){
            ForEach(beaches.beaches.filter({ $0.tileId == players.players[0].tilePositionId})) { beach in
                ZStack {
                    Text("\(beach.beachName)")
                        .font(.system(size: 15, weight: .heavy, design: .monospaced))
                        .foregroundColor(.white)
                        .frame(width: 210, height: 24)
                        .background(Color(players.players[0].color.rawValue).opacity(0.8))
                    
                    Button {
                        buyingMessage = false
                    } label: {
                        Image(systemName: "xmark")
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                            .font(.system(size: 15, weight: .heavy, design: .monospaced))
                        
                    }
                    .offset(x: 93)
                }
                .padding(.bottom, 5)

                VStack (spacing: 4){
                    ForEach(1..<5, id: \.self) { index in
                        if (index == 1) {
                            HStack (spacing: 0){
                                Text("level").frame(width: 150)
                                Text("rent").frame(width: 60)
                            }
                            .frame(width: 210, height: 24)
                            .border(.black, width: 0.2)
                            .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        }

                        
                        HStack (spacing: 0){
                            HStack (spacing: 0) {
                                Text("own")
                                Text(" \(index) ")
                                Text(index < 2 ? "beach" : "beaches")
                            }
                            .frame(width: 150)
                            Text("\(beach.rentByLevel[index])$").frame(width: 60)
                        }
                        .frame(width: 210, height: 16)
                        .font(.system(size: 12, weight: .regular, design: .monospaced))
                    }
                    
                }
                .padding(.bottom, 3)
                .border(.black, width: 0.2)
                
                VStack {
                    Button {
                        buyingMessage = false
                        if beaches.buyBeach(player: &players.players[0]) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                                    beachBoughtMessage = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                                    beachBoughtMessage = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                totalBuyingCost = 0
                            }
                        }
                        else {
                            totalBuyingCost = 0
                        }
                    } label: {
                        if (players.players[0].money >= beach.cost) {
                            HStack (spacing: 0) {
                                Text("buy-for")
                                Text(": \(beach.cost)$")
                            }
                            .font(.system(size: 13, weight: .bold, design: .default))
                            .frame(width: 150, height: 24)
                            .background(Color(players.players[0].color.rawValue))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.top, 5)
                        }
                        else {
                            HStack (spacing: 0) {
                                Text("not-enough-money")
                            }
                            .font(.system(size: 13, weight: .bold, design: .default))
                            .frame(width: 160, height: 24)
                            .background(Color(players.players[0].color.rawValue))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.top, 5)
                        }
                    }
                }
                .padding(.bottom, 6)

            }
        }
        .border(.black, width: 0.2)
    }
}

struct BuyingBeachView_Previews: PreviewProvider {
    static var previews: some View {
        BuyingBeachView(buyingMessage: .constant(true), totalBuyingCost: .constant(0), beachBoughtMessage: .constant(false), beaches: BeachModel(), players: PlayerModel())
    }
}
