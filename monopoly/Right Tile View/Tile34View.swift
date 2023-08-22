//
//  Tile34View.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct Tile34View: View {
    var body: some View {
        ZStack {
            ZStack{
                Spacer()
                    .frame(width: 18, height: 10)
                    .background(.blue.opacity(0.9))
                    .offset(x: 6, y: -25)
                Text("TOKYO")
                    .frame(width: 60, height: 12)
                    .rotationEffect(Angle(degrees: 90))
                    .font(.system(size: 8.5, weight: .medium, design: .default))
                    .foregroundColor(.blue)
                    .offset(x: -9)
            }
            .frame(width: 30, height: 60)
            .border(.black, width: 0.3)
        .offset(x: -75, y: 150)
        }
    }
}

struct Tile34View_Previews: PreviewProvider {
    static var previews: some View {
        Tile34View()
    }
}
