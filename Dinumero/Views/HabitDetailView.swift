import SwiftUI

struct HabitDetailView: View {
    @Bindable var habit: Habit

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 16) {
                    Text(habit.title)
                        .font(.system(.title, design: .default, weight: .bold))
                        .foregroundStyle(habit.colour.color)

                    HStack {
                        Text("Day \(habit.displayDay) of \(habit.lengthDays)")
                            .font(.system(.body, design: .default, weight: .bold))
                            .foregroundStyle(Theme.text)

                        if habit.showStreak {
                            Spacer()

                            Text("\(habit.currentStreak) 🔥")
                                .font(.system(.body, design: .default, weight: .bold))
                                .foregroundStyle(Theme.text)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top)

                DayGridView(habit: habit)
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Theme.background.ignoresSafeArea())
    }
}

#Preview {
    HabitDetailView(habit: Habit(title: "Read", colour: .blue, startDate: .now, lengthDays: 28))
}
