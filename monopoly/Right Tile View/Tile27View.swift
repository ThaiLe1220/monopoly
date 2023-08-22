//
//  Tile27View.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct Tile27View: View {
    var body: some View {
        ZStack {
            ZStack{
                Text("WOLRD TOUR")
                    .rotationEffect(Angle(degrees: 135))
                    .font(.system(size: 7, weight: .ultraLight, design: .monospaced))
            }
            .frame(width: 60, height: 60)
            .border(.black, width: 0.3)
        .offset(x: 150, y: 150)
        }
    }
}

struct Tile27View_Previews: PreviewProvider {
    static var previews: some View {
        Tile27View()
    }
}
