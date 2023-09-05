//
//  Tile23View.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct Tile23View: View {
    @Binding var showTileDetailedInfo: Bool
    @Binding var selectedTileId: Int
    
    var body: some View {
        ZStack {
            ZStack{
                ChanceTileView()
            }
            .frame(width: 30, height: 60)
            .border(.black, width: 0.2)
            .offset(x: -15, y: 150)
        }
    }
}

struct Tile23View_Previews: PreviewProvider {
    static var previews: some View {
        Tile23View(showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1))
    }
}
