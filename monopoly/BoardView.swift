////
////  BoardView.swift
////  monopoly
////
////  Created by Lê Ngọc Trâm on 18/08/2023.
////
//
//import SwiftUI
//
//struct BoardView: View {
//    
//    @Binding var currentPlayer = testPlayer1
//    @Binding var playerAI1 = testPlayer2
//    @Binding var playerAI2 = testPlayer3
//    @Binding var playerAI3 = testPlayer4
//    
//    var body: some View {
//        /// BOARD VIEW
//        ZStack() {
//            ZStack {
//                Circle()
//    //                        .trim(from: 1/2, to: 1)
//                    .stroke(style: StrokeStyle(lineWidth: 1, dash:  [6, 6]))
//                    .frame(width: 150)
//                    .foregroundColor(.yellow)
//                
//                
//                Image(systemName: "sun.max")
//                    .font(.title2)
//                    .foregroundColor(.yellow)
//                    .offset(x: -75)
//                    .rotationEffect(.degrees(sunMoving ? 360: 0))
//                    .animation(.easeOut(duration: 6).delay(0.5).repeatForever(autoreverses: false), value: sunMoving)
//                    .onAppear(){
//                        sunMoving.toggle()
//                    }
//            }
//            
//            HStack {
//                Button(action: {
//                    moveForward(player: &currentPlayer)
//                }){
//                    Image(systemName: "plus")
//                        .foregroundColor(.yellow)
//                }
//
//                Button(action: {
//                    moveBackward(player: &currentPlayer)
//                    
//                }){
//                    Image(systemName: "minus")
//                        .foregroundColor(.yellow)
//                }
//            }
//            
//            Image(systemName: "person.crop.circle")
//                .offset(x: currentPlayer.tilePosition.posX - 8, y: currentPlayer.tilePosition.posY - 8)
//                .rotationEffect(Angle(degrees: currentPlayer.tilePosition.angle))
//                .font(.system(size: 12))
//                .foregroundColor(Color("Player1"))
//            
//            Image(systemName: "person.crop.circle")
//                .offset(x: playerAI1.tilePosition.posX + 8, y: playerAI1.tilePosition.posY - 8)
//                .rotationEffect(Angle(degrees: playerAI1.tilePosition.angle))
//                .font(.system(size: 12))
//                .foregroundColor(Color("Player2"))
//            
//            Image(systemName: "person.crop.circle")
//                .offset(x: playerAI2.tilePosition.posX + 8, y: playerAI2.tilePosition.posY + 8)
//                .rotationEffect(Angle(degrees: playerAI2.tilePosition.angle))
//                .font(.system(size: 12))
//                .foregroundColor(Color("Player3"))
//           
//            Image(systemName: "person.crop.circle")
//                .offset(x: playerAI3.tilePosition.posX - 8, y: playerAI3.tilePosition.posY + 8)
//                .rotationEffect(Angle(degrees: playerAI3.tilePosition.angle))
//                .font(.system(size: 12))
//                .foregroundColor(Color("Player4"))
//
//            /// bottom section
//            ZStack {
//                ZStack{
//                    Text("0")
//                }
//                .frame(width: 60, height: 60)
//                .border(.black)
//                .offset(x: 150, y: 150)
//                
//                ZStack{
//                    Text("1")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: 105, y: 150)
//                
//                ZStack{
//                    Text("2")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: 75, y: 150)
//                ZStack{
//                    Text("3")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: 45, y: 150)
//                ZStack{
//                    Text("4")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: 15, y: 150)
//                ZStack{
//                    Text("5")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: -15, y: 150)
//                ZStack{
//                    Text("6")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: -45, y: 150)
//                ZStack{
//                    Text("7")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: -75, y: 150)
//                
//                ZStack{
//                    Text("8")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: -105, y: 150)
//            }
//            .font(.system(size: 12))
//            .frame(width: 360, height: 360)
//            .border(.black)
//            .rotationEffect(Angle(degrees: 0))
//            
//            /// left section
//            ZStack {
//                ZStack{
//                    Text("9")
//                }
//                .frame(width: 60, height: 60)
//                .border(.black)
//                .offset(x: 150, y: 150)
//                
//                ZStack{
//                    Text("10")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: 105, y: 150)
//                
//                ZStack{
//                    Text("11")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: 75, y: 150)
//                ZStack{
//                    Text("12")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: 45, y: 150)
//                ZStack{
//                    Text("13")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: 15, y: 150)
//                ZStack{
//                    Text("14")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: -15, y: 150)
//                ZStack{
//                    Text("15")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: -45, y: 150)
//                ZStack{
//                    Text("16")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: -75, y: 150)
//                
//                ZStack{
//                    Text("17")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: -105, y: 150)
//            }
//            .font(.system(size: 12))
//            .frame(width: 360, height: 360)
//            .border(.black)
//            .rotationEffect(Angle(degrees: 90))
//            
//            /// top section
//            ZStack {
//                ZStack{
//                    Text("18")
//                }
//                .frame(width: 60, height: 60)
//                .border(.black)
//                .offset(x: 150, y: 150)
//                
//                ZStack{
//                    Text("19")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: 105, y: 150)
//                
//                ZStack{
//                    Text("20")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: 75, y: 150)
//                ZStack{
//                    Text("21")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: 45, y: 150)
//                ZStack{
//                    Text("22")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: 15, y: 150)
//                ZStack{
//                    Text("23")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: -15, y: 150)
//                ZStack{
//                    Text("24")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: -45, y: 150)
//                ZStack{
//                    Text("25")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: -75, y: 150)
//                
//                ZStack{
//                    Text("26")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: -105, y: 150)
//            }
//            .font(.system(size: 12))
//            .frame(width: 360, height: 360)
//            .border(.black)
//            .rotationEffect(Angle(degrees: 180))
//            
//            /// right section
//            ZStack {
//                ZStack{
//                    Text("27")
//                }
//                .frame(width: 60, height: 60)
//                .border(.black)
//                .offset(x: 150, y: 150)
//                
//                ZStack{
//                    Text("28")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: 105, y: 150)
//                
//                ZStack{
//                    Text("29")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: 75, y: 150)
//                ZStack{
//                    Text("30")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: 45, y: 150)
//                ZStack{
//                    Text("31")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: 15, y: 150)
//                ZStack{
//                    Text("32")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: -15, y: 150)
//                ZStack{
//                    Text("33")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: -45, y: 150)
//                ZStack{
//                    Text("34")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: -75, y: 150)
//                
//                ZStack{
//                    Text("35")
//                }
//                .frame(width: 30, height: 60)
//                .border(.black)
//                .offset(x: -105, y: 150)
//            }
//            .font(.system(size: 12))
//            .frame(width: 360, height: 360)
//            .border(.black)
//            .rotationEffect(Angle(degrees: 270))
//            
//        }
//        
//    }
//}
//
//struct BoardView_Previews: PreviewProvider {
//    static var previews: some View {
//        BoardView()
//    }
//}

