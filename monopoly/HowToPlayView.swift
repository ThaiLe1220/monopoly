//
//  HowToPlayView.swift
//  monopoly
//
//  Created by Lê Ngọc Trâm on 06/09/2023.
//

import SwiftUI

struct HowToPlayView: View {
    @AppStorage("game") private var gameData: Data = Data()
    @StateObject var game = GameModel()
    
    @State private var expandedSections = Set<Int>()
    let rules = [
        ("general-information", "general-information-detail"),
        ("dice-rule", "dice-rule-detail"),
        ("turn-rule", "turn-rule-detail"),
        ("winning-and-game-over", "winning-and-game-over-detail"),
        ("start-tile", "start-tile-detail"),
        ("city-tile", "city-tile-detail"),
        ("beach-tile", "beach-tile-detail"),
        ("tax-tile", "tax-tile-detail"),
        ("money-tile", "money-tile-detail"),
        ("lost-island-tile", "lost-island-detail"),
        ("championship-tile", "championship-detail"),
        ("world-tour-tile", "world-tour-tile-detail"),
        ("chances-tile", "chances-tile-detail")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(Array(rules.enumerated()), id: \.offset) { index, rule in
                    RuleSection(title: rule.0, description: rule.1, isExpanded: expandedSections.contains(index)) {
                        withAnimation {
                            if expandedSections.contains(index) {
                                expandedSections.remove(index)
                            } else {
                                expandedSections.insert(index)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            loadGame()
        }
        .environment(\.locale, Locale.init(identifier: game.game.language))

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

struct HowToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        HowToPlayView()
    }
}


struct RuleSection: View {
    var title: String
    var description: String
    var isExpanded: Bool
    var toggle: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Text(NSLocalizedString(title, comment: "vi"))
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.right.circle")
                    .rotationEffect(.degrees(isExpanded ? 90 : 0))
            }
            .contentShape(Rectangle())
            .onTapGesture(perform: toggle)
            
            if isExpanded {
                Text(NSLocalizedString(description, comment: ""))
                    .transition(.slide)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 4)
                    .frame(width: 360)
                    .border(.black, width: 1.4)
            }
        }
        .animation(.linear(duration: 0.3), value: isExpanded)

    }

}
