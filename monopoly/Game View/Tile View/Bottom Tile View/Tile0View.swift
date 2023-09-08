
/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 2
  Author: Le Hong Thai
  ID: s3752577
  Created  date: 16/08/2023
  Last modified: 8/09/2023
  Acknowledgement: Acknowledge the resources that you use here.
*/


import SwiftUI

struct Tile0View: View {
    @Binding var showTileDetailedInfo: Bool
    @Binding var selectedTileId: Int
    
    var tiles:[TilePosition] = TilePositionModel().tiles
    
    @State private var isAnimating = false
    var body: some View {
        ZStack {
            ZStack{
                ZStack {
                    Text("START")
                        .font(.system(size: 12, weight: .regular, design: .monospaced))
                        .rotation3DEffect(.degrees(isAnimating ? 360*4 : 0), axis: (x: 1, y: 0, z: 0))
                        .rotationEffect(Angle(degrees: -45))
                        .animation(.linear(duration: 3), value: isAnimating)
                    
                     
                    Image(systemName: "arrowshape.turn.up.backward.2.fill")
                        .rotation3DEffect(.degrees(isAnimating ? 360*2 : 0), axis: (x: 0, y: 0, z: 1))
                        .font(.system(size: 9))
                        .offset(x: -19, y: -19)
                        .animation(.linear(duration: 1.5).delay(0.5), value: isAnimating)
                        .foregroundColor(.red)
                        
                    Image(systemName: "arrowshape.turn.up.backward.2.fill")
                        .rotation3DEffect(.degrees(isAnimating ? 360*2 : 0), axis: (x: 0, y: 0, z: 1))
                        .rotationEffect(Angle(degrees: -180))

                        .font(.system(size: 9))
                        .offset(x: 19, y: 19)
                        .animation(.linear(duration: 1.5).delay(0.5), value: isAnimating)
                        .foregroundColor(.red)

                }
                .onAppear {
                    isAnimating.toggle()
                    Timer.scheduledTimer(withTimeInterval: 6, repeats: true) { timer in
                        self.isAnimating.toggle()
                    }
                }

                
                    /// BORDER
                ZStack {
                    Spacer()
                        .frame(width: 1.4, height: 61.4)
                        .background(.black.opacity(0.7))
                        .offset(x:-30)
                    Spacer()
                        .frame(width: 1.4, height: 61.4)
                        .background(.black.opacity(0.7))
                        .offset(x:30)
                    Spacer()
                        .frame(width: 60, height: 1.4)
                        .background(.black.opacity(0.7))
                        .offset(y:30)
                    Spacer()
                        .frame(width: 60, height: 1.4)
                        .background(.black.opacity(0.7))
                        .offset(y:-30)
                }
            }
            .frame(width: 60, height: 60)
            .offset(x: 150, y: 150)
        }
    }
}

struct Tile0View_Previews: PreviewProvider {
    static var previews: some View {
        Tile0View(showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1))
    }
}
