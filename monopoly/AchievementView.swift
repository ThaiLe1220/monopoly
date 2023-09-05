import SwiftUI

struct AchievementView: View {
    var achievement: Achievement

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(achievement.title)
                    .font(.headline)
            }
            Spacer()
            Image(systemName: achievement.completed ? "checkmark.circle.fill" : "circle")
                .foregroundColor(achievement.completed ? .green : .gray)
        }
        .padding()
        .background(achievement.completed ? Color("AvocadoGreen").opacity(0.4) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(achievement.completed ? Color("AvocadoGreen") : Color.gray, lineWidth: 2)
        )
        .padding(.horizontal)
    }
}

struct AchievementView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementView(achievement: AchievementModel().achievements[0])
    }
}
