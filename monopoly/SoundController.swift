////
////  SoundController.swift
////  monopoly
////
////  Created by Thai, Le Hong on 05/09/2023.
////
//
//import Foundation
//import AVFoundation
//
//
//var background: AVAudioPlayer!
//
//
//func playBackground() {
//    let url = Bundle.main.url(forResource: "background", withExtension: ".mp3")
//        
//    guard url != nil else {
//        return
//    }
//    
//    do {
//        background = try AVAudioPlayer(contentsOf: url!)
//        background?.play()
//    }
//    catch {
//        print(error)
//    }
//}
