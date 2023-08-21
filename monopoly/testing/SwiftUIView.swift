//
//  SwiftUIView.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 20/08/2023.
//


import SwiftUI

struct SwiftUIView: View {
    @State private var isPopupVisible = false

    var body: some View {
        ZStack {
            Button {isPopupVisible.toggle()} label: {
                Text("Show Popup")
            }
            .offset(x: 0, y: -100)
            
            if isPopupVisible {
                ZStack {
                    Color.gray.opacity(0.15)
                        .ignoresSafeArea()
                    VStack {
                        Text("This is a text popup")
                            .background(.white)
                        
                        Button {isPopupVisible = false} label: {
                            Text("OK")
                        }
                    }
                    
                    
                }
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
