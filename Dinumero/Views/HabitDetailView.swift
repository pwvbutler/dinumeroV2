import SwiftUI

struct HabitDetailView: View {
    @Bindable var habit: Habit

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(habit.title)
                    .font(.system(.title, design: .default, weight: .bold))
                    .foregroundStyle(habit.colour.color)

                Text("Day \(habit.daysSinceStart) of \(habit.lengthDays)")
                    .font(.system(.body, design: .default, weight: .bold))
                    .foregroundStyle(Theme.text)

                DayGridView(habit: habit)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Theme.background)
    }
}

#Preview {
    HabitDetailView(habit: Habit(title: "Read", colour: .blue, startDate: .now, lengthDays: 28))
}
