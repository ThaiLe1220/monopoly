//
//  TaxTileView.swift
//  monopoly
//
//  Created by Thai, Le Hong on 28/08/2023.
//

import SwiftUI

struct TaxTileView: View {
    @ObservedObject var players:PlayerModel
    @Binding var showTileDetailedInfo: Bool
    @Binding var selectedTileId: Int
    
    var body: some View {
        ZStack {
            ZStack (){
            
    //                Image(systemName: "banknote.fill")
    //                    .font(.system(size: 10))
    //                    .foregroundColor(.green)
                
                Image(systemName: "dollarsign")
                    .font(.system(size: 8))
                    .foregroundColor(.green)
                    .offset(x: 0, y: -20)

                Text("TAX")
                    .frame(width: 30, height: 10)
                    .font(.system(size: 7, weight: .semibold, design: .monospaced))
                
                Image(systemName: "dollarsign")
                    .font(.system(size: 8))
                    .foregroundColor(.green)
                    .offset(x: 0, y: 20)
                
                Spacer()
                    .frame(width: 30, height: 10)
                    .offset(x: 0, y: -25)
                
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
        }
    }
}

struct TaxTileView_Previews: PreviewProvider {
    static var previews: some View {
        TaxTileView(players: PlayerModel(), showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1))
    }
}
