import SwiftUI
import SwiftData

struct HabitListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.startDate) private var habits: [Habit]

    @State private var selectedHabit: Habit?
    @State private var habitPendingDelete: Habit?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(habits) { habit in
                        HabitPillButton(title: habit.title, colour: habit.colour.color)
                            .contentShape(Rectangle())
                            .onTapGesture { selectedHabit = habit }
                            .onLongPressGesture { habitPendingDelete = habit }
                            .accessibilityElement(children: .combine)
                            .accessibilityAddTraits(.isButton)
                    }

                    NavigationLink(value: "add") {
                        Text("Add Habit")
                            .font(.system(.body, design: .default, weight: .bold))
                            .foregroundStyle(Theme.text)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .overlay(
                                Rectangle()
                                    .stroke(Theme.text, style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding()
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationDestination(item: $selectedHabit) { habit in
                HabitDetailView(habit: habit)
            }
            .navigationDestination(for: String.self) { _ in
                AddHabitView()
            }
            .toolbarBackground(Theme.background, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .tint(Theme.text)
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
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

#Preview {
    HabitListView()
        .modelContainer(for: Habit.self, inMemory: true)
}
