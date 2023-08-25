//
//  Tile16View.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct Tile16View: View {
    @Binding var showTileDetailedInfo: Bool
    @Binding var selectedTileId: Int
    
    var body: some View {
        ZStack {
            ZStack{
                Text("CYRUS")
                    .frame(width: 30, height: 10)
                    .border(.black, width: 0.3)
                    .font(.system(size: 7, weight: .ultraLight, design: .default))
                
            }
            .frame(width: 30, height: 60)
            .background(.brown.opacity(0.25))
            .border(.black, width: 0.2)
            .offset(x: -75, y: 150)
        }
    }
}

struct Tile16View_Previews: PreviewProvider {
    static var previews: some View {
        Tile16View(showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1))
    }
}