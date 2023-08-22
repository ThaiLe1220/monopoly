//
//  Tile11View.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 22/08/2023.
//

import SwiftUI

struct Tile11View: View {
    var body: some View {
        ZStack {
            ZStack{
                Text("FREE")
                    .frame(width: 30, height: 10)
                    .border(.black, width: 0.3)
                    .font(.system(size: 7, weight: .ultraLight, design: .monospaced))
                    .offset(y: -5)
                Text("$100")
                    .frame(width: 30, height: 10)
                    .border(.black, width: 0.3)
                    .font(.system(size: 7, weight: .ultraLight, design: .monospaced))
                    .offset(y: 5)
            }
            .frame(width: 30, height: 60)
            .border(.black, width: 0.3)
        .offset(x: 75, y: 150)
        }
    }
}

struct Tile11View_Previews: PreviewProvider {
    static var previews: some View {
        Tile11View()
    }
}
