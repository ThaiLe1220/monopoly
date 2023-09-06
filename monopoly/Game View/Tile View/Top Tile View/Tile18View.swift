//
//  Tile18View.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct Tile18View: View {
    @Binding var showTileDetailedInfo: Bool
    @Binding var selectedTileId: Int
    
    var body: some View {
        ZStack {
            ZStack{
                Text("RMIT")
                    .rotationEffect(Angle(degrees: 135))
                    .font(.system(size: 9, weight: .regular, design: .monospaced))
                    .offset(x: 6, y: 6)
                
                Text("CHAMPION")
                    .rotationEffect(Angle(degrees: 135))
                    .font(.system(size: 9, weight: .regular, design: .monospaced))
                    .offset(x: -2, y: -2)
                
                /// BORDER
                ZStack {
                    Spacer()
                        .frame(width: 1.4, height: 61.4)
                        .background(.black.opacity(0.7))
                        .offset(x:-30)
                    Spacer()
                        .frame(width: 1.4, height: 61.4)
                        .background(.black.opacity(0.7))
                        .offset(x:30)
                    Spacer()
                        .frame(width: 60, height: 1.4)
                        .background(.black.opacity(0.7))
                        .offset(y:30)
                    Spacer()
                        .frame(width: 60, height: 1.4)
                        .background(.black.opacity(0.7))
                        .offset(y:-30)
                }
            }
            .frame(width: 60, height: 60)
            .border(.black, width: 0.2)
            .offset(x: 150, y: 150)
        }
    }
}

struct Tile18View_Previews: PreviewProvider {
    static var previews: some View {
        Tile18View(showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1))
    }
}
