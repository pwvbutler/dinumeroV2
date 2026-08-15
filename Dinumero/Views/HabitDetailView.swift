import SwiftUI

// Placeholder — fleshed out in Phase 4 (day grid, days-since-started).
struct HabitDetailView: View {
    @Bindable var habit: Habit

    var body: some View {
        Text(habit.title)
            .font(.system(.title, design: .default, weight: .bold))
            .foregroundStyle(habit.colour.color)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.background)
    }
}
