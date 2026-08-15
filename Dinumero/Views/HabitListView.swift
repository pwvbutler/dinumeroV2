import SwiftUI
import SwiftData

struct HabitListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.sortOrder) private var habits: [Habit]

    @State private var habitPendingDelete: Habit?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(habits) { habit in
                        NavigationLink(value: habit.id) {
                            HabitPillButton(title: habit.title, colour: habit.colour.color)
                        }
                        .buttonStyle(.plain)
                        .onLongPressGesture {
                            habitPendingDelete = habit
                        }
                    }

                    NavigationLink(value: "add") {
                        Text("Add Habit")
                            .font(.system(.body, design: .default, weight: .bold))
                            .foregroundStyle(Theme.text)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 0)
                                    .stroke(Theme.text, style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding()
            }
            .background(Theme.background)
            .navigationDestination(for: UUID.self) { id in
                if let habit = habits.first(where: { $0.id == id }) {
                    HabitDetailView(habit: habit)
                }
            }
            .navigationDestination(for: String.self) { _ in
                AddHabitView()
            }
        }
        .statusBarHidden()
        .confirmationDialog(
            "Delete \(habitPendingDelete?.title ?? "")?",
            isPresented: Binding(
                get: { habitPendingDelete != nil },
                set: { if !$0 { habitPendingDelete = nil } }
            ),
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                if let habit = habitPendingDelete {
                    modelContext.delete(habit)
                }
                habitPendingDelete = nil
            }
            Button("Cancel", role: .cancel) {
                habitPendingDelete = nil
            }
        }
    }
}

#Preview {
    HabitListView()
        .modelContainer(for: Habit.self, inMemory: true)
}
