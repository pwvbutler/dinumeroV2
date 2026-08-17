import SwiftUI
import SwiftData

struct AddHabitView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var colour: HabitColour = .blue
    @State private var lengthDays = 28
    @State private var showDayNumbers = true
    @State private var showStreak = true

    private static let titleCharacterLimit = 25

    private var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canSubmit: Bool {
        !trimmedTitle.isEmpty
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            TextField("Habit title", text: $title)
                .font(.system(.title2, design: .default, weight: .bold))
                .foregroundStyle(Theme.text)
                .onChange(of: title) { _, newValue in
                    if newValue.count > Self.titleCharacterLimit {
                        title = String(newValue.prefix(Self.titleCharacterLimit))
                    }
                }

            ColourSwatchPicker(selection: $colour)

            Stepper("Length: \(lengthDays) days", value: $lengthDays, in: 1...365)
                .foregroundStyle(Theme.text)

            VStack(spacing: 12) {
                ToggleChip(label: "Show day numbers", isOn: $showDayNumbers, accent: colour.color)
                ToggleChip(label: "Show streak counter", isOn: $showStreak, accent: colour.color)
            }

            Spacer()

            HStack(spacing: 16) {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundStyle(Theme.text)

                Spacer()

                Button("Add Habit") {
                    let habit = Habit(
                        title: trimmedTitle,
                        colour: colour,
                        startDate: .now,
                        lengthDays: lengthDays,
                        showDayNumbers: showDayNumbers,
                        showStreak: showStreak
                    )
                    modelContext.insert(habit)
                    dismiss()
                }
                .foregroundStyle(canSubmit ? colour.color : Theme.text.opacity(0.3))
                .disabled(!canSubmit)
            }
            .font(.system(.body, design: .default, weight: .bold))
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Theme.background)
    }
}

#Preview {
    AddHabitView()
        .modelContainer(for: Habit.self, inMemory: true)
}
