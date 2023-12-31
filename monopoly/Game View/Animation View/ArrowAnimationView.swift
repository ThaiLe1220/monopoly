
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

struct ArrowAnimationView: View {
    @State private var showDollar = false
    @State private var showDollarAnimation = false
    @State private var delayTime = 0.25
    var body: some View {
        ZStack {
            Image(systemName: "arrowtriangle.forward.fill")
                .resizable()
                .frame(width: 4*3.7, height: 3*3.9)
                .rotationEffect(Angle(degrees: -36))
                .offset(x: -45, y: -30)
                .opacity(showDollar ? 1 : 0)
                .animation(.linear(duration: delayTime).delay(delayTime*1), value: showDollar)

            
            Image(systemName: "arrowtriangle.forward.fill")
                .resizable()
                .frame(width: 4*3.3, height: 3*3.5)
                .rotationEffect(Angle(degrees: -19))
                .offset(x: -22, y: -45)
                .opacity(showDollar ? 1 : 0)
                .animation(.linear(duration: delayTime).delay(delayTime*2), value: showDollar)

            
            Image(systemName: "arrowtriangle.forward.fill")
                .resizable()
                .frame(width: 4*2.9, height: 3*3.1)
                .rotationEffect(Angle(degrees: 5))
                .offset(x: 6, y: -49)
                .opacity(showDollar ? 1 : 0)
                .animation(.linear(duration: delayTime).delay(delayTime*3), value: showDollar)

            
            Image(systemName: "arrowtriangle.forward.fill")
                .resizable()
                .frame(width: 4*2.5, height: 3*2.7)
                .rotationEffect(Angle(degrees: 21))
                .offset(x: 30, y: -42)
                .opacity(showDollar ? 1 : 0)
                .animation(.linear(duration: delayTime).delay(delayTime*4), value: showDollar)

            
            Image(systemName: "arrowtriangle.forward.fill")
                .resizable()
                .frame(width: 4*2.1, height: 3*2.3)
                .rotationEffect(Angle(degrees: 35))
                .offset(x: 50, y: -31)
                .opacity(showDollar ? 1 : 0)
                .animation(.linear(duration: delayTime).delay(delayTime*5), value: showDollar)

            // Dollar sign
            Image(systemName: "dollarsign")
                .font(.system(size: 15))
                .offset(x: 70, y: showDollar ? -50 : 0)
                .animation(.easeOut(duration: 0.8), value: showDollar)
                .opacity(showDollarAnimation ? 0 : 1)
                .onAppear {
                    showDollar = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + delayTime*4) {
                            showDollarAnimation = true
                    }

                }

            // Rolling dollar sign
            Image(systemName: "dollarsign")
                .font(.system(size: 15))
                .rotation3DEffect(.degrees(showDollarAnimation ? 360*6 : 0), axis: (x: 0, y: 1, z: 0))
                .offset(x: 70, y: -50)
                .animation(.linear(duration: 2), value: showDollarAnimation)
                .opacity(showDollarAnimation ? 1 : 0)

        
        }
        .foregroundColor(.green)
    }
}

struct ArrowAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        ArrowAnimationView()
    }
}

