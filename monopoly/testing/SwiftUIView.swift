//
//  SwiftUIView.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 20/08/2023.
//


import SwiftUI

struct SwiftUIView: View {

    @State var timeLeft = 10.0
    @State var timer: Timer?
    
    var body: some View {
        ZStack {
           
//            Circle()
//                .stroke(.red, lineWidth: 3)
//                .frame(width: 100)
            
            if timeLeft > 0 {
                Circle()
                    .trim(from: 0, to: CGFloat(timeLeft/10))
                    .stroke(.red, lineWidth: 3)
                    .frame(width: 100)
                    .rotationEffect(.degrees(-90))
            }
            
            Text("\(timeLeft)")
            Button("start")
            {
                startT()
            }
            .offset(y: 40)
        }
    }
    
    private func startT() {
        timeLeft = 10
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if timeLeft > 0 {
                timeLeft -= 0.1
            }
            else {
                timer.invalidate()
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
