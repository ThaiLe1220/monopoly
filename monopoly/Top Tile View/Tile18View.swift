//
//  Tile18View.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct Tile18View: View {
    var body: some View {
        ZStack {
            ZStack{
                Text("WOLRD")
                    .rotationEffect(Angle(degrees: 135))
                    .font(.system(size: 7, weight: .ultraLight, design: .monospaced))
                    .offset(x: 6, y: 6)
                
                Text("CHAMPIONSHIPS")
                    .rotationEffect(Angle(degrees: 135))
                    .font(.system(size: 7, weight: .ultraLight, design: .monospaced))
                    .offset(x: -2, y: -2)
            }
            .frame(width: 60, height: 60)
            .border(.black, width: 0.3)
        .offset(x: 150, y: 150)
        }
    }
}

struct Tile18View_Previews: PreviewProvider {
    static var previews: some View {
        Tile18View()
    }
}
