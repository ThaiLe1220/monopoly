//
//  ChanceTileView.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 05/09/2023.
//

import SwiftUI

struct ChanceTileView: View {
    
    @State private var isAnimating = false

    var body: some View {
        ZStack{
          
            Text("CHANCE")
                .frame(width: 40, height: 10)
                .font(.system(size: 9, weight: .semibold, design: .monospaced))
                .rotationEffect(Angle(degrees: 90))
                .foregroundColor(.purple)
            
            Image(systemName: "questionmark")
                .rotation3DEffect(.degrees(isAnimating ? 360*2 : 0), axis: (x: 0, y: 1, z: 0))
                .rotationEffect(Angle(degrees: -45))
                .font(.system(size: 9, weight: .bold))
                .offset(x: -8, y: -23)
                .animation(.linear(duration: 1.5).delay(0.5), value: isAnimating)
                .foregroundColor(.purple)
            
            Image(systemName: "questionmark")
                .rotation3DEffect(.degrees(isAnimating ? 360*2 : 0), axis: (x: 0, y: 1, z: 0))
                .rotationEffect(Angle(degrees: -135))
                .font(.system(size: 9, weight: .bold))
                .offset(x: -8, y: 23)
                .animation(.easeInOut(duration: 1.5).delay(0.5), value: isAnimating)
                .foregroundColor(.purple)
            
            Image(systemName: "questionmark")
                .rotation3DEffect(.degrees(isAnimating ? 360*2 : 0), axis: (x: 0, y: 1, z: 0))
                .rotationEffect(Angle(degrees: 45))
                .font(.system(size: 9, weight: .bold))
                .offset(x: 8, y: -23)
                .animation(.easeInOut(duration: 1.5).delay(0.5), value: isAnimating)
                .foregroundColor(.purple)
            
            Image(systemName: "questionmark")
                .rotation3DEffect(.degrees(isAnimating ? 360*2 : 0), axis: (x: 0, y: 1, z: 0))
                .rotationEffect(Angle(degrees: 135))
                .font(.system(size: 9, weight: .bold))
                .offset(x: 8, y: 23)                .animation(.linear(duration: 1.5).delay(0.5), value: isAnimating)
                .foregroundColor(.purple)
            
            /// BORDER
            ZStack {
                Spacer()
                    .frame(width: 1.4, height: 61.4)
                    .background(.black.opacity(0.7))
                .offset(x:-15)
                Spacer()
                    .frame(width: 1.4, height: 61.4)
                    .background(.black.opacity(0.7))
                    .offset(x:15)
                Spacer()
                    .frame(width: 30, height: 1.4)
                    .background(.black.opacity(0.7))
                    .offset(y:30)
                Spacer()
                    .frame(width: 30, height: 1.4)
                    .background(.black.opacity(0.7))
                    .offset(y:-30)
            }
            
        }
        .onAppear {
            isAnimating.toggle()
            Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
                self.isAnimating.toggle()
            }
        }
    }
}

struct ChanceTileView_Previews: PreviewProvider {
    static var previews: some View {
        ChanceTileView()
    }
}
