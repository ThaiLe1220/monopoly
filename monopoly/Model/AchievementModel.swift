//
//  AchievementModel.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 05/09/2023.
//

import Foundation
import CoreLocation

class AchievementModel: ObservableObject {
    @Published var achievements: [Achievement] = []

    init(){ achievements = decodeFromJson(file: "Achievement.json") }        
    func decodeFromJson(file: String) -> [Achievement] {
//        print("decodeFromJson invoked, filename: \(file)")
        if let file = Bundle.main.url(forResource: file, withExtension: nil){
            if let data = try? Data(contentsOf: file) {
                do {
                    let decoded = try JSONDecoder().decode([Achievement].self, from: data)
                    return decoded
                } catch let error {
                    fatalError("Failed to decode JSON: \(error)")
                }
            }
        } else {
            fatalError("Couldn't load \(file) file")
        }
        return [ ] as [Achievement]
    }
    
}
