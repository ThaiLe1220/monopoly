//
//  AchievementsView.swift
//  monopoly
//
//  Created by Thai, Le Hong on 05/09/2023.
//

import SwiftUI

struct AchievementsView: View {
    @ObservedObject var achivements = AchievementModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(achivements.achievements) { achievement in
                    AchievementView(achievement: achievement)
                }
            }
            .navigationBarTitle("Achievements", displayMode: .inline)
        }
    }
}


struct AchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementsView()
    }
}
