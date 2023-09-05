//
//  BuyingOptionView.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 24/08/2023.
//

import SwiftUI

struct BuyingCityView: View {
    
    @Binding var buyingMessage: Bool
    @Binding var cityBuyingOption: Set<Int>
    @Binding var totalBuyingCost: Int
    @Binding var cityBoughtMessage: Bool

    @ObservedObject var cities:CityModel
    @ObservedObject var players:PlayerModel

    var body: some View {
        VStack (spacing: 0) {
            Spacer().frame(height: 30)
            ForEach(cities.cities.filter({ $0.tileId == players.players[0].tilePositionId})) { city in
                ZStack {
                    Text("\(city.cityName)")
                        .font(.system(size: 15, weight: .heavy, design: .monospaced))
                        .foregroundColor(.white)
                        .frame(width: 210, height: 24)
                        .background(Color(players.players[0].color.rawValue))
                    
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

                
                VStack (spacing: 3){
                    ForEach(1..<6, id: \.self) { index in
                        if index == 1 {
                            HStack (spacing: 0){
                                Text("level").frame(width: 90)
                                Text("rent").frame(width: 50)
                                Text("cost").frame(width: 50)
                                Spacer().frame(width: 20)
                            }
                            .frame(width: 210, height: 20)
                            .border(.black, width: 0.2)
                            .font(.system(size: 13, weight: .semibold, design: .monospaced))
                            
                            HStack (spacing: 0){
                                Text("Land").frame(width: 90)
                                Text("\(city.rentByLevel[index])").frame(width: 50)
                                Text("\(city.costByLevel[index-1])").frame(width: 50)
                                Image(systemName: cityBuyingOption.contains(index) ? "checkmark.square" : "square")
                                    .onTapGesture {
                                        toggleBuyingOption(index, city)
                                    }
                                    .frame(width: 20)
                            }
                            .frame(width: 210, height: 16)
                            .font(.system(size: 12, weight: .regular, design: .monospaced))
                        }
                        else if index == 5 {
                            HStack (spacing: 0){
                                Text("hotel")
                                    .frame(width: 90)
                                Text("\(city.rentByLevel[index])").frame(width: 50)
                                Text("\(city.costByLevel[index-1])").frame(width: 50)
                                Image(systemName: cityBuyingOption.contains(index) ? "checkmark.square" : "square")
                                    .onTapGesture {
                                        toggleBuyingOption(index, city)
                                    }
                                    .frame(width: 20)
                                    .opacity(city.currentLevel == 4 ? 1 : 0)

                            }
                            .frame(width: 210, height: 16)
                            .font(.system(size: 12, weight: .regular, design: .monospaced))
                        }
                        else {
                            HStack (spacing: 0){
                                HStack(spacing: 0) {
                                    Text("house")
                                    Text(" \(index-1)")
                                }
                                .frame(width: 90)
                                Text("\(city.rentByLevel[index])$").frame(width: 50)
                                Text("\(city.costByLevel[index-1])$").frame(width: 50)
                                if index == 4 {
                                    Image(systemName: cityBuyingOption.contains(index) ? "checkmark.square" : "square")
                                        .onTapGesture {
                                            toggleBuyingOption(index, city)
                                        }
                                        .frame(width: 20)
                                        .opacity(city.currentLevel == 3 ? 1 : 0)
                                }
                                else {
                                    Image(systemName: cityBuyingOption.contains(index) ? "checkmark.square" : "square")
                                        .onTapGesture {
                                            toggleBuyingOption(index, city)
                                        }
                                        .frame(width: 20)
                                }

                            }
                            .frame(width: 210, height: 16)
                            .font(.system(size: 12, weight: .regular, design: .monospaced))
                        }
                    }
                }
                .padding(.bottom, 3)
                .border(.black, width: 0.2)
                
                VStack {
                    Button {
                        cities.buyCity(player: &players.players[0], options: cityBuyingOption)
                        withAnimation(.linear(duration: 0.3)) {
                            buyingMessage = false
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                cityBoughtMessage = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4.7) {
                                cityBoughtMessage = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            totalBuyingCost = 0
                        }

                    } label: {
                        HStack (spacing: 0) {
                            Text("buy-for")
                            Text(": \(totalBuyingCost)$")
                        }
                        .font(.system(size: 13, weight: .bold, design: .default))
                        .frame(width: 150, height: 24)
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
    
    func toggleBuyingOption(_ number: Int, _ city: City) {
        if cityBuyingOption.contains(number) {
            for n in number...5 {
                if cityBuyingOption.contains(n) {
                    totalBuyingCost -= city.costByLevel[n-1]
                }
                cityBuyingOption.remove(n)
            }
        } else {
            for n in 1...number {
                if !cityBuyingOption.contains(n) {
                    totalBuyingCost += city.costByLevel[n-1]
                }
                cityBuyingOption.insert(n)
            }
        
        }
    }

}

struct BuyingCityView_Previews: PreviewProvider {
    static var previews: some View {
        BuyingCityView(buyingMessage: .constant(true), cityBuyingOption: .constant([]), totalBuyingCost: .constant(0), cityBoughtMessage: .constant(false), cities: CityModel(), players: PlayerModel())
    }
}
