//
//  BuyingBeachView.swift
//  monopoly
//
//  Created by Trang Le on 02/09/2023.
//

import SwiftUI

struct BuyingBeachView: View {
    @Binding var buyingMessage: Bool
    @Binding var totalBuyingCost : Int
    @Binding var beachBoughtMessage: Bool

    @ObservedObject var beaches:BeachModel
    @ObservedObject var players:PlayerModel
    
    var body: some View {
        VStack (spacing: 0){
            Spacer().frame(height: 30)

            ForEach(beaches.beaches.filter({ $0.tileId == players.players[0].tilePositionId})) { beach in
                ZStack {
                    Text("\(beach.beachName)")
                        .font(.system(size: 15, weight: .heavy, design: .monospaced))
                        .foregroundColor(.white)
                        .frame(width: 210, height: 24)
                        .background(Color(players.players[0].color.rawValue).opacity(0.8))
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            buyingMessage = false
                        }
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
                                Text("Level").frame(width: 150)
                                Text("Rent").frame(width: 60)
                            }
                            .frame(width: 210, height: 24)
                            .border(.black, width: 0.2)
                            .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        }

                        
                        HStack (spacing: 0){
                            Text(index < 2 ? "Own \(index) beach" : "Own \(index) beaches")
                                .frame(width: 150)
                            Text("\(beach.rentByLevel[index])").frame(width: 60)
                        }
                        .frame(width: 210, height: 16)
                        .font(.system(size: 12, weight: .regular, design: .monospaced))
                    }
                    
                }
                .padding(.bottom, 3)
                .border(.black, width: 0.2)
                
                VStack {
                    Button {
                        beaches.buyBeach(player: &players.players[0])
                        withAnimation(.linear(duration: 0.3)) {
                            buyingMessage = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                beachBoughtMessage = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.7) {
                                beachBoughtMessage = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            totalBuyingCost = 0
                        }
                        
                    } label: {
                        HStack {
                            Text("Buy For: ")
                            Text("\(beach.cost)$")
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
        }
        .frame(width: 210, height: 190)
    }
}

struct BuyingBeachView_Previews: PreviewProvider {
    static var previews: some View {
        BuyingBeachView(buyingMessage: .constant(true), totalBuyingCost: .constant(0), beachBoughtMessage: .constant(false), beaches: BeachModel(), players: PlayerModel())
    }
}
