import SwiftUI

struct DayGridView: View {
    @Bindable var habit: Habit

    private let daysPerRow = 5
    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 0), count: daysPerRow)
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(0..<habit.lengthDays, id: \.self) { day in
                let isCompleted = habit.completedDays.contains(day)
                let isToday = habit.todayIndex == day
                Rectangle()
                    .fill(isCompleted ? habit.colour.color : Theme.background)
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(
                        Rectangle()
                            .strokeBorder(habit.colour.color, lineWidth: isToday ? 6 : 2)
                    )
                    .overlay(
                        Text("\(day + 1)")
                            .font(.system(.body, design: .default, weight: .bold))
                            .foregroundStyle(Theme.secondaryText)
                    )
                    .onTapGesture {
                        if isCompleted {
                            habit.completedDays.remove(day)
                        } else {
                            habit.completedDays.insert(day)
                        }
                    }
            }
        }
    }
}

#Preview {
    DayGridView(habit: Habit(title: "Read", colour: .blue, startDate: .now, lengthDays: 28))
        .padding()
        .background(Theme.background)
}
