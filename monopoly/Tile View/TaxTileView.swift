//
//  TaxTileView.swift
//  monopoly
//
//  Created by Thai, Le Hong on 28/08/2023.
//

import SwiftUI

struct TaxTileView: View {
    @ObservedObject var players:PlayerModel
    @Binding var showTileDetailedInfo: Bool
    @Binding var selectedTileId: Int
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct TaxTileView_Previews: PreviewProvider {
    static var previews: some View {
        TaxTileView(players: PlayerModel(), showTileDetailedInfo: .constant(false), selectedTileId: .constant(-1))
    }
}
