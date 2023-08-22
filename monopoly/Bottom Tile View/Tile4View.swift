//
//  Tile4View.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct Tile4View: View {
    var body: some View {
        ZStack {
            ZStack{
                Text("TAX")
                    .frame(width: 30, height: 10)
                    .border(.black, width: 0.3)
                    .font(.system(size: 7, weight: .light, design: .monospaced))
            }
            .frame(width: 30, height: 60)
            .border(.black, width: 0.3)
        .offset(x: 15, y: 150)
        }
    }
}

struct Tile4View_Previews: PreviewProvider {
    static var previews: some View {
        Tile4View()
    }
}