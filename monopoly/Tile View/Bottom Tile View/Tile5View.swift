//
//  Tile5View.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct Tile5View: View {
    @Binding var showTileDetailedInfo: Bool
    @Binding var selectedTileId: Int
    
    var body: some View {
        ZStack {
            ZStack{
                Text("BALI")
                    .frame(width: 30, height: 10)
                    .border(.black, width: 0.3)
                    .font(.system(size: 7, weight: .light, design: .monospaced))
            }
            .frame(width: 30, height: 60)
            .background(.brown.opacity(0.25))
            .border(.black, width: 0.2)
            .offset(x: -15, y: 150)
        }
    }
}

struct Tile5View_Previews: PreviewProvider {
    static var previews: some View {
        Tile5View(showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1))
    }
}
