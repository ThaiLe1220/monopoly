
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

struct DollarSignAnimation: View {
    @Binding var isAnimating: Bool
    
    @State private var xPosition: CGFloat = -20
    @State private var yPosition: CGFloat = -10
    @State private var xPosition2: CGFloat = 20
    @State private var yPosition2: CGFloat = 10
    
    @State private var xPosition3: CGFloat = -20
    @State private var yPosition3: CGFloat = 10
    @State private var xPosition4: CGFloat = 20
    @State private var yPosition4: CGFloat = -10
    
    var body: some View {
        ZStack {
            Spacer()
                .frame(width: 40, height: 20)
            
            Text("$")
                .rotationEffect(Angle(degrees: 90))
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(.green)
                .offset(x: xPosition, y: yPosition)
                .onChange(of: isAnimating) { newValue in
                    if newValue {
                        restartAnimation()
                    }
                }

            Text("$")
                .rotationEffect(Angle(degrees: 90))
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(.green)
                .offset(x: xPosition2, y: yPosition2)
                .onChange(of: isAnimating) { newValue in
                    if newValue {
                        restartAnimation2()
                    }
                }
            
            Text("$")
                .rotationEffect(Angle(degrees: 90))
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(.green)
                .offset(x: xPosition3, y: yPosition3)
                .onChange(of: isAnimating) { newValue in
                    if newValue {
                        restartAnimation5()
                    }
                }
            
            Text("$")
                .rotationEffect(Angle(degrees: 90))
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(.green)
                .offset(x: xPosition4, y: yPosition4)
                .onChange(of: isAnimating) { newValue in
                    if newValue {
                        restartAnimation6()
                    }
                }

        }
    }
    
    private func restartAnimation() {
        withAnimation(Animation.linear(duration: 1.6)) {
            xPosition = 20
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            withAnimation(Animation.linear(duration: 0.8)) {
                yPosition = 10
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            withAnimation(Animation.linear(duration: 1.6)) {
                xPosition = -20
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            withAnimation(Animation.linear(duration: 0.8)) {
                yPosition = -10
            }
        }
    }
    
    private func restartAnimation2() {
        withAnimation(Animation.linear(duration: 1.6)) {
            xPosition2 = -20
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            withAnimation(Animation.linear(duration: 0.8)) {
                yPosition2 = -10
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            withAnimation(Animation.linear(duration: 1.6)) {
                xPosition2 = 20
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            withAnimation(Animation.linear(duration: 0.8)) {
                yPosition2 = 10
            }
        }
    }
    
    private func restartAnimation3() {
        withAnimation(Animation.linear(duration: 0.8)) {
            yPosition3 = -10
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(Animation.linear(duration: 1.6)) {
                xPosition3 = 20
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            withAnimation(Animation.linear(duration: 0.8)) {
                yPosition3 = 10
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
            withAnimation(Animation.linear(duration: 1.6)) {
                xPosition3 = -20
            }
        }
    }
    
    private func restartAnimation4() {
        withAnimation(Animation.linear(duration: 0.8)) {
            yPosition4 = 10
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(Animation.linear(duration: 1.6)) {
                xPosition4 = -20
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            withAnimation(Animation.linear(duration: 0.8)) {
                yPosition4 = -10
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.2) {
            withAnimation(Animation.linear(duration: 1.6)) {
                xPosition4 = 20
            }
        }
    }
    
    private func restartAnimation5() {
        withAnimation(Animation.linear(duration: 1.6)) {
            xPosition3 = 20
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            withAnimation(Animation.linear(duration: 0.8)) {
                yPosition3 = -10
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            withAnimation(Animation.linear(duration: 1.6)) {
                xPosition3 = -20
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            withAnimation(Animation.linear(duration: 0.8)) {
                yPosition3 = 10
            }
        }
    }
    
    private func restartAnimation6() {
        withAnimation(Animation.linear(duration: 1.6)) {
            xPosition4 = -20
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            withAnimation(Animation.linear(duration: 0.8)) {
                yPosition4 = 10
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            withAnimation(Animation.linear(duration: 1.6)) {
                xPosition4 = 20
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            withAnimation(Animation.linear(duration: 0.8)) {
                yPosition4 = -10
            }
        }
    }
    



}

struct DollarSignAnimation_Previews: PreviewProvider {
    static var previews: some View {
        DollarSignAnimation(isAnimating: .constant(true))
    }
}
