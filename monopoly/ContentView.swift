//
//  ContentView.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 16/08/2023.
//

import SwiftUI

struct ContentView: View {
    
    var tiles:[TilePosition] = TilePositionModel().tiles
    @State var currentTile: TilePosition = testTilePosition
    @State var currentTileId: Int = 0
    @State var sunMoving: Bool = false
    
    @State var dice1: Int = 1
    @State var dice2: Int = 1
    var totalDice: Int { dice1 + dice2 }
    
    
    var body: some View {
        VStack{
            Spacer().frame(height: 100)
            
            /// BOARD VIEW
            ZStack() {
                
                ZStack {
                    Circle()
//                        .trim(from: 1/2, to: 1)
                        .stroke(style: StrokeStyle(lineWidth: 1, dash:  [6, 6]))
                        .frame(width: 150)
                        .foregroundColor(.yellow)
                    
                    
                    Image(systemName: "sun.max")
                        .font(.title2)
                        .foregroundColor(.yellow)
                        .offset(x: -75)
                        .rotationEffect(.degrees(sunMoving ? 360: 0))
                        .animation(.easeOut(duration: 6).delay(0.5).repeatForever(autoreverses: false), value: sunMoving)
                        .onAppear(){
                            sunMoving.toggle()
                        }
                }
                
                
                HStack {
                    Button(action: {
                       moveForward()
                    }){
                        Image(systemName: "plus")
                            .foregroundColor(.yellow)
                    }

                    Button(action: {
                        currentTileId -= 1
                        if currentTileId < 0 {currentTileId = 35}
                        
                        withAnimation(Animation.easeOut(duration: 0.3)){
                            currentTile = tiles[currentTileId]
                        }
                    }){
                        Image(systemName: "minus")
                            .foregroundColor(.yellow)
                    }
                }
                
                Image(systemName: "pawprint.fill")
                    .offset(x: currentTile.posX, y: currentTile.posY)
                    .rotationEffect(Angle(degrees: currentTile.angle))
                    .font(.system(size: 12))
                    .foregroundColor(.yellow)
                
//                Image(systemName: "pawprint.fill")
//                    .offset(x: currentTile.posX - 8, y: currentTile.posY - 8)
//                    .rotationEffect(Angle(degrees: currentTile.angle))
//                    .font(.system(size: 12))
//                    .foregroundColor(.red)
//
//                Image(systemName: "pawprint.fill")
//                    .offset(x: currentTile.posX + 8, y: currentTile.posY - 8)
//                    .rotationEffect(Angle(degrees: currentTile.angle))
//                    .font(.system(size: 12))
//                    .foregroundColor(.brown)
//
//                Image(systemName: "pawprint.fill")
//                    .offset(x: currentTile.posX + 8, y: currentTile.posY + 8)
//                    .rotationEffect(Angle(degrees: currentTile.angle))
//                    .font(.system(size: 13))
//                    .foregroundColor(.orange)
//
//                Image(systemName: "pawprint.fill")
//                    .offset(x: currentTile.posX - 8, y: currentTile.posY + 8)
//                    .rotationEffect(Angle(degrees: currentTile.angle))
//                    .font(.system(size: 12))
//                    .foregroundColor(.purple)

                // bottom section
                ZStack {
                    ZStack{
                        Text("0")
                    }
                    .frame(width: 60, height: 60)
                    .border(.black)
                    .offset(x: 150, y: 150)
                    
                    ZStack{
                        Text("1")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: 105, y: 150)
                    
                    ZStack{
                        Text("2")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: 75, y: 150)
                    ZStack{
                        Text("3")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: 45, y: 150)
                    ZStack{
                        Text("4")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: 15, y: 150)
                    ZStack{
                        Text("5")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: -15, y: 150)
                    ZStack{
                        Text("6")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: -45, y: 150)
                    ZStack{
                        Text("7")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: -75, y: 150)
                    
                    ZStack{
                        Text("8")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: -105, y: 150)
                }
                .font(.system(size: 12))
                .frame(width: 360, height: 360)
                .border(.black)
                .rotationEffect(Angle(degrees: 0))
                

                // left section
                ZStack {
                    ZStack{
                        Text("9")
                    }
                    .frame(width: 60, height: 60)
                    .border(.black)
                    .offset(x: 150, y: 150)
                    
                    ZStack{
                        Text("10")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: 105, y: 150)
                    
                    ZStack{
                        Text("11")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: 75, y: 150)
                    ZStack{
                        Text("12")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: 45, y: 150)
                    ZStack{
                        Text("13")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: 15, y: 150)
                    ZStack{
                        Text("14")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: -15, y: 150)
                    ZStack{
                        Text("15")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: -45, y: 150)
                    ZStack{
                        Text("16")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: -75, y: 150)
                    
                    ZStack{
                        Text("17")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: -105, y: 150)
                }
                .font(.system(size: 12))
                .frame(width: 360, height: 360)
                .border(.black)
                .rotationEffect(Angle(degrees: 90))
                
              
                // top section
                ZStack {
                    ZStack{
                        Text("18")
                    }
                    .frame(width: 60, height: 60)
                    .border(.black)
                    .offset(x: 150, y: 150)
                    
                    ZStack{
                        Text("19")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: 105, y: 150)
                    
                    ZStack{
                        Text("20")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: 75, y: 150)
                    ZStack{
                        Text("21")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: 45, y: 150)
                    ZStack{
                        Text("22")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: 15, y: 150)
                    ZStack{
                        Text("23")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: -15, y: 150)
                    ZStack{
                        Text("24")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: -45, y: 150)
                    ZStack{
                        Text("25")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: -75, y: 150)
                    
                    ZStack{
                        Text("26")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: -105, y: 150)
                }
                .font(.system(size: 12))
                .frame(width: 360, height: 360)
                .border(.black)
                .rotationEffect(Angle(degrees: 180))
                
                    
                // right section
                ZStack {
                    ZStack{
                        Text("27")
                    }
                    .frame(width: 60, height: 60)
                    .border(.black)
                    .offset(x: 150, y: 150)
                    
                    ZStack{
                        Text("28")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: 105, y: 150)
                    
                    ZStack{
                        Text("29")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: 75, y: 150)
                    ZStack{
                        Text("30")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: 45, y: 150)
                    ZStack{
                        Text("31")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: 15, y: 150)
                    ZStack{
                        Text("32")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: -15, y: 150)
                    ZStack{
                        Text("33")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: -45, y: 150)
                    ZStack{
                        Text("34")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: -75, y: 150)
                    
                    ZStack{
                        Text("35")
                    }
                    .frame(width: 30, height: 60)
                    .border(.black)
                    .offset(x: -105, y: 150)
                }
                .font(.system(size: 12))
                .frame(width: 360, height: 360)
                .border(.black)
                .rotationEffect(Angle(degrees: 270))
                
            }
            
            
            /// DICE VIEW
            HStack() {
                Spacer()
                
                ZStack {
                    Button  {
                        var delayRoll:Double = 0
                        for _ in 0..<15 {
                            withAnimation(.linear(duration: 0.08).delay(delayRoll)){
                                dice1 = diceRoll(excluding: dice1)
                                dice2 = diceRoll(excluding: dice2)
                                delayRoll += 0.08
                            }
                        
                        }
                        
                        let delayMove: Double = 1.2
                        DispatchQueue.main.asyncAfter(deadline: .now() + delayMove) {
                            moveForwardBySteps(steps: totalDice)
                        }
                        
                    } label: {
                        Image("dice\(dice1)")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(7.5)
                        Image("dice\(dice2)")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .cornerRadius(7.5)

                    }
                }
                .frame(width: 100, height: 50)
//                .background(.blue)
                .border(.black, width: 0.3)

        
                Spacer()
            }
            
            Spacer()

        }
        .border(.black)

    }
    
    
    func moveForward(){
        var nextTileId:Int
        if currentTileId >= 35 {nextTileId = 0} else {nextTileId = currentTileId + 1}
        let nextTile:TilePosition = tiles[nextTileId]

        /// moving in bottom section
        if nextTileId >= 1 && nextTileId < 10 {
            let diffX = currentTile.posX - nextTile.posX
            withAnimation(.linear(duration: 0.07)){
                currentTile.posX -= diffX*1/4
                currentTile.posY -= 20*2/3
            }
            withAnimation(Animation.linear(duration: 0.1).delay(0.07)){
                currentTile.posX -= diffX*1/4
                currentTile.posY -= 20*1/3
            }
            withAnimation(Animation.linear(duration: 0.06).delay(0.17)){
                currentTile.posX -= diffX*1/4
                currentTile.posY += 20*1/3
            }
            withAnimation(Animation.linear(duration: 0.07).delay(0.23)){
                currentTile = nextTile
                currentTileId = nextTileId
            }
        }
        /// moving in left section
        if nextTileId >= 10 && nextTileId < 10+9 {
            let diffY = currentTile.posY - nextTile.posY
            
            withAnimation(.linear(duration: 0.07)){
                currentTile.posX += 20*2/3
                currentTile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.1).delay(0.07)){
                currentTile.posX += 20*1/3
                currentTile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.06).delay(0.17)){
                currentTile.posX -= 20*1/3
                currentTile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.07).delay(0.23)){
                currentTile = nextTile
                currentTileId = nextTileId
            }
        }
        /// moving in top section
        if nextTileId >= 10+9 && nextTileId < 10+9+9 {
            let diffX = currentTile.posX - nextTile.posX
            withAnimation(.linear(duration: 0.07)){
                currentTile.posX -= diffX*1/4
                currentTile.posY += 20*2/3
            }
            withAnimation(Animation.linear(duration: 0.1).delay(0.07)){
                currentTile.posX -= diffX*1/4
                currentTile.posY += 20*1/3
            }
            withAnimation(Animation.linear(duration: 0.06).delay(0.17)){
                currentTile.posX -= diffX*1/4
                currentTile.posY -= 20*1/3
            }
            withAnimation(Animation.linear(duration: 0.07).delay(0.23)){
                currentTile = nextTile
                currentTileId = nextTileId
            }
        }
        /// moving in left section
        if nextTileId >= 10+9+9 && nextTileId < 10+9+9+9 || nextTileId == 0 {
            let diffY = currentTile.posY - nextTile.posY
            
            withAnimation(.linear(duration: 0.07)){
                currentTile.posX -= 20*2/3
                currentTile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.1).delay(0.07)){
                currentTile.posX -= 20*1/3
                currentTile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.06).delay(0.17)){
                currentTile.posX += 20*1/3
                currentTile.posY -= diffY*1/4
            }
            withAnimation(Animation.linear(duration: 0.07).delay(0.23)){
                currentTile = nextTile
                currentTileId = nextTileId
            }
        }
    
    }
    
    func diceRoll(excluding num: Int) -> Int{
        var ran = Int.random(in: 1...6)
        while ran == num {
            ran = Int.random(in: 1...6)
        }
        return ran
    }
    
    func moveForwardBySteps(steps: Int){
        var delayMove: Double = 0
        for _ in 0..<steps {
            delayMove += 0.3
            DispatchQueue.main.asyncAfter(deadline: .now() + delayMove) {
                moveForward()
            }
        }
    }
    
    func moveForwardToTile(targetTileId: Int){
    
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
