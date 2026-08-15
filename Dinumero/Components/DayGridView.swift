import SwiftUI

struct DayGridView: View {
    @Bindable var habit: Habit

    private let columns = Array(repeating: GridItem(.fixed(44), spacing: 8), count: 5)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(0..<habit.lengthDays, id: \.self) { day in
                let isCompleted = habit.completedDays.contains(day)
                Rectangle()
                    .fill(isCompleted ? habit.colour.color : Theme.background)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Rectangle()
                            .stroke(habit.colour.color, lineWidth: 2)
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
