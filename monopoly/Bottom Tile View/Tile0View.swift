//
//  Tile0View.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct Tile0View: View {
    var body: some View {
        ZStack {
            ZStack{
                Text("Start")
                    .rotationEffect(Angle(degrees: -45))
            }
            .frame(width: 60, height: 60)
            .border(.black, width: 0.3)
        .offset(x: 150, y: 150)
        }
    }
}

struct Tile0View_Previews: PreviewProvider {
    static var previews: some View {
        Tile0View()
    }
}