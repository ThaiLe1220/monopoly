
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


import SwiftUI

struct AchievementsView: View {
    @ObservedObject var achievements = AchievementModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(achievements.achievements) { achievement in
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
