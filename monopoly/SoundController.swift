
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


import Foundation
import AVFoundation


var background: AVAudioPlayer!


func playBackground() {
    let url = Bundle.main.url(forResource: "background", withExtension: ".mp3")
        
    guard url != nil else {
        return
    }
    
    do {
        background = try AVAudioPlayer(contentsOf: url!)
        background?.play()
    }
    catch {
        print(error)
    }
}
