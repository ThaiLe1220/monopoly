
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

struct TaxTileView: View {
    @ObservedObject var players:PlayerModel

    @Binding var showTileDetailedInfo: Bool
    @Binding var selectedTileId: Int
    
    @State private var isAnimating = false
       
    var body: some View {
        ZStack {
            ZStack (){
                Text("TAX")
                    .frame(width: 30, height: 10)
                    .font(.system(size: 9, weight: .semibold, design: .monospaced))
                    .rotationEffect(Angle(degrees: 90))
                    .foregroundColor(.green)

                
                ZStack {
                    DollarSignAnimation(isAnimating: $isAnimating)
                }
                .rotationEffect(Angle(degrees: -90))
                .onAppear {
                    isAnimating.toggle()
                    startAnimation()
                }
                
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
        }
    }
    
    func startAnimation() {
        Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { timer in
            self.isAnimating.toggle()
        }
    }
}

struct TaxTileView_Previews: PreviewProvider {
    static var previews: some View {
        TaxTileView(players: PlayerModel(), showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1))
    }
}
