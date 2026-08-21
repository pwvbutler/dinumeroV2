import SwiftUI
import SwiftData

struct AddHabitView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var colour: HabitColour = .blue
    @State private var lengthDays = 28
    @State private var timesPerDay = 1
    @State private var showDayNumbers = false
    @State private var showStreak = false
    @State private var hapticFeedback = false
    @State private var todayHighlightStyle: TodayHighlightStyle = .accentBorder

    private static let titleCharacterLimit = 25

    private var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canSubmit: Bool {
        !trimmedTitle.isEmpty
    }

    /// The form scrolls rather than compressing: at default text sizes the
    /// fields alone are taller than a small device's screen, so a fixed
    /// `VStack` had no slack to give up when the keyboard appeared and
    /// SwiftUI shifted the whole screen up instead. A `ScrollView` absorbs
    /// the keyboard inset by scrolling, and keeps the form usable at large
    /// Dynamic Type sizes too.
    var body: some View {
        ScrollView {
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

                Stepper("Times per day: \(timesPerDay)", value: $timesPerDay, in: 1...10)
                    .foregroundStyle(Theme.text)

                VStack(spacing: 12) {
                    ToggleChip(label: "Show day numbers", isOn: $showDayNumbers, accent: Theme.secondaryText)
                    ToggleChip(label: "Show streak counter", isOn: $showStreak, accent: Theme.secondaryText)
                    ToggleChip(label: "Haptic feedback", isOn: $hapticFeedback, accent: Theme.secondaryText)
                    TodayHighlightStylePicker(selection: $todayHighlightStyle, accent: Theme.secondaryText)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollDismissesKeyboard(.interactively)
        .background(Theme.background.ignoresSafeArea())
        .safeAreaInset(edge: .bottom) {
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
                        timesPerDay: timesPerDay,
                        showDayNumbers: showDayNumbers,
                        showStreak: showStreak,
                        hapticFeedback: hapticFeedback,
                        todayHighlightStyle: todayHighlightStyle
                    )
                    modelContext.insert(habit)
                    dismiss()
                }
                .foregroundStyle(canSubmit ? colour.color : Theme.text.opacity(0.3))
                .disabled(!canSubmit)
            }
            .font(.system(.body, design: .default, weight: .bold))
            .padding()
            .background(Theme.background)
        }
    }
}

#Preview {
    AddHabitView()
        .modelContainer(for: Habit.self, inMemory: true)
}
