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
                        .padding(.horizontal, -24)
                        .padding(.horizontal, -2)
                }
            }
            .navigationBarTitle("Achievements")
        }
    }
}


struct AchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementsView()
    }
}
