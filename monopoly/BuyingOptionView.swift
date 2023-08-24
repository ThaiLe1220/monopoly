//
//  BuyingOptionView.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 24/08/2023.
//

import SwiftUI

struct BuyingOptionView: View {
    
    @Binding var buyingMessage: Bool
    @Binding var tickedBuyingOption : Set<Int>
    @Binding var totalBuyingCost : Int
    @Binding var gamePlayer : Player
    @ObservedObject var cities:CityModel

    var body: some View {
        VStack (spacing: 4) {
            ForEach(cities.cities.filter({ $0.tileId == gamePlayer.tilePositionId})) { city in
                ZStack {
                    Text("\(city.cityName)")
                        .font(.system(size: 16, weight: .heavy, design: .monospaced))
                        .foregroundColor(.white)
                        .frame(width: 230, height: 24)
                        .background(Color(gamePlayer.color.rawValue).opacity(0.8))
                    
                    Button {
                        buyingMessage = false
                    } label: {
                        Image(systemName: "xmark")
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .heavy, design: .monospaced))
                        
                    }
                    .offset(x: 103)
                    
                }
                
                VStack (spacing: 4){
                    ForEach(1..<6, id: \.self) { index in
                        if (index == 1) {
                            HStack (spacing: 0){
                                Text("Level")
                                    .frame(width: 100)
                                Text("Rent").frame(width: 50)
                                Text("Cost").frame(width: 50)
                                Spacer().frame(width: 20)
                            }
                            .frame(width: 230, height: 24)
                            .border(.black, width: 0.2)
                            .font(.system(size: 13, weight: .semibold, design: .monospaced))
                            
                            HStack (spacing: 0){
                                Text("Land")
                                    .frame(width: 100)
                                Text("\(city.rentByLevel[index])").frame(width: 50)
                                Text("\(city.costByLevel[index-1])").frame(width: 50)
                                Image(systemName: tickedBuyingOption.contains(index) ? "checkmark.square" : "square")
                                    .onTapGesture {
                                        toggleBuyingOption(index, city)
                                    }
                                
                            }
                            .frame(width: 230, height: 16)
                            .font(.system(size: 13, weight: .regular, design: .monospaced))
                        }
                        else if (index == 5) {
                            HStack (spacing: 0){
                                Text("Hotel")
                                    .frame(width: 100)
                                Text("\(city.rentByLevel[index])").frame(width: 50)
                                Text("\(city.costByLevel[index-1])").frame(width: 50)
                                Image(systemName: tickedBuyingOption.contains(index) ? "checkmark.square" : "square")
                                    .onTapGesture {
                                        toggleBuyingOption(index, city)
                                    }
                            }
                            .frame(width: 230, height: 16)
                            .font(.system(size: 13, weight: .regular, design: .monospaced))
                        }
                        else {
                            HStack (spacing: 0){
                                Text("House \(index-1)")
                                    .frame(width: 100)
                                Text("\(city.rentByLevel[index])").frame(width: 50)
                                Text("\(city.costByLevel[index-1])").frame(width: 50)
                                Image(systemName: tickedBuyingOption.contains(index) ? "checkmark.square" : "square")
                                    .onTapGesture {
                                        toggleBuyingOption(index, city)
                                    }
                            }
                            .frame(width: 230, height: 16)
                            .font(.system(size: 13, weight: .regular, design: .monospaced))
                        }
                        
                    }
                    
                }
                .padding(.bottom, 8)
                .border(.black, width: 0.2)
                
                VStack {
                    Button {
                        cities.buyProperty(player: &gamePlayer, tickedBuyingOption: tickedBuyingOption)
                        buyingMessage = false
                    } label: {
                        HStack {
                            Text("Buy For: ")
                            Text("\(totalBuyingCost) $")
                        }
                        .font(.system(size: 14, weight: .bold, design: .default))
                        .frame(width: 160, height: 24)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        
                    }
                }
            }
        }
    }
    
    func toggleBuyingOption(_ number: Int, _ city: City) {
        if tickedBuyingOption.contains(number) {
            for n in number...5 {
                if tickedBuyingOption.contains(n) {
                    totalBuyingCost -= city.costByLevel[n-1]
                }
                tickedBuyingOption.remove(n)
            }
        } else {
            for n in 1...number {
                if !tickedBuyingOption.contains(n) {
                    totalBuyingCost += city.costByLevel[n-1]
                }
                tickedBuyingOption.insert(n)
            }
        
        }
    }

}

struct BuyingOptionView_Previews: PreviewProvider {
    static var previews: some View {
        BuyingOptionView(buyingMessage: .constant(true), tickedBuyingOption: .constant([]), totalBuyingCost: .constant(0), gamePlayer: .constant(player1), cities: CityModel())
    }
}
