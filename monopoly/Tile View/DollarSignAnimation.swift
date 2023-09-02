//
//  DollarSignAnimation.swift
//  monopoly
//
//  Created by Trang Le on 02/09/2023.
//

import SwiftUI

struct DollarSignAnimation: View {
    @Binding var isAnimating: Bool
    
    @State private var xPosition: CGFloat = -20
    @State private var yPosition: CGFloat = -10
    @State private var xPosition2: CGFloat = 20
    @State private var yPosition2: CGFloat = 10
    
    
    var body: some View {
        ZStack {
            Spacer()
                .frame(width: 40, height: 20)
//                .border(.green, width: 0.3)
            
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

}

struct DollarSignAnimation_Previews: PreviewProvider {
    static var previews: some View {
        DollarSignAnimation(isAnimating: .constant(true))
    }
}
