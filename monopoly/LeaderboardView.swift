import SwiftUI

struct LeaderboardView: View {
    @AppStorage("game") private var gameData: Data = Data()
    @StateObject var game = GameModel()
    var tiles:[TilePosition] = TilePositionModel().tiles

    var body: some View {
        NavigationView {
            List {
                ForEach(game.game.players, id: \.id) { player in
                    playerRow(player: player)
                }
            }
        }
        .onAppear {
            loadGame()
        }
        .onDisappear {
            loadGame()
        }
    }

    @ViewBuilder
    private func playerRow(player: Player) -> some View {
        VStack(alignment: .leading) {
            Text(player.name)
                .fontWeight(.medium)
            Text("Money: $\(player.money)")
                .foregroundColor(player.money >= 0 ? .green : .red)
            
            ForEach(player.tilePropertyIds, id: \.self) { tileId in
                propertyRow(tileId: tileId)
            }
        }
    }

    @ViewBuilder
    private func propertyRow(tileId: Int) -> some View {
        if let tile = tiles.first(where: { $0.id == tileId }) {
            switch tile.type {
            case .city:
                if let city = game.game.cities.first(where: { $0.tileId == tileId }) {
                    Text("City: \(city.cityName), Level: \(city.currentLevel), Rent: \(city.rent)")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            case .beach:
                if let beach = game.game.beaches.first(where: { $0.tileId == tileId }) {
                    Text("Beach: \(beach.beachName), Level: \(beach.currentLevel), Rent: \(beach.rent)")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                }
            default:
                Text("Other type of property")
            }
        }
    }

    
    func loadGame() {
        do {
            let decoded = try JSONDecoder().decode(Game.self, from: gameData)
            self.game.game = decoded
            print("[game loaded]", terminator: ", ")
        } catch {
            print("Error loading game")
        }
    }
}



struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView(game: GameModel())
    }
}
