


import Foundation
import CoreLocation

class TilePositionModel{
    var tiles: [TilePosition] = []
    
    init(){ tiles = decodeFromJson(file: "TilePosition.json") }
        
    func decodeFromJson(file: String) -> [TilePosition] {
//        print("decodeFromJson invoked, filename: \(file)")
        if let file = Bundle.main.url(forResource: file, withExtension: nil){
            if let data = try? Data(contentsOf: file) {
                do {
                    let decoded = try JSONDecoder().decode([TilePosition].self, from: data)
                    return decoded
                } catch let error {
                    fatalError("Failed to decode JSON: \(error)")
                }
            }
        } else {
            fatalError("Couldn't load \(file) file")
        }
        return [ ] as [TilePosition]
    }
    
}

