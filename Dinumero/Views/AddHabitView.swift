import SwiftUI

// Placeholder — fleshed out in Phase 3 (title field, colour picker, day-count stepper).
struct AddHabitView: View {
    var body: some View {
        Text("Add Habit")
            .font(.system(.title, design: .default, weight: .bold))
            .foregroundStyle(Theme.text)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Theme.background)
    }
}
