import SwiftUI

struct DayGridView: View {
    @Bindable var habit: Habit

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 5)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(0..<habit.lengthDays, id: \.self) { day in
                let isCompleted = habit.completedDays.contains(day)
                Rectangle()
                    .fill(isCompleted ? habit.colour.color : Theme.background)
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(
                        Rectangle()
                            .stroke(habit.colour.color, lineWidth: 2)
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
