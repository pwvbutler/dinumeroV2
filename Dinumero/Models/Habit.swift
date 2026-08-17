import Foundation
import SwiftData

@Model
final class Habit {
    var id: UUID
    var title: String
    var colour: HabitColour
    var startDate: Date
    var lengthDays: Int
    var completedDays: [Int]
    var sortOrder: Int
    var showDayNumbers: Bool = false
    var showStreak: Bool = false
    var hapticFeedback: Bool = false
    var todayHighlightStyle: TodayHighlightStyle = TodayHighlightStyle.accentBorder

    init(
        id: UUID = UUID(),
        title: String,
        colour: HabitColour,
        startDate: Date,
        lengthDays: Int,
        completedDays: [Int] = [],
        sortOrder: Int = 0,
        showDayNumbers: Bool = false,
        showStreak: Bool = false,
        hapticFeedback: Bool = false,
        todayHighlightStyle: TodayHighlightStyle = .accentBorder
    ) {
        self.id = id
        self.title = title
        self.colour = colour
        self.startDate = startDate
        self.lengthDays = lengthDays
        self.completedDays = completedDays
        self.sortOrder = sortOrder
        self.showDayNumbers = showDayNumbers
        self.showStreak = showStreak
        self.hapticFeedback = hapticFeedback
        self.todayHighlightStyle = todayHighlightStyle
    }

    /// Day 1 on the start date, incrementing once per calendar day thereafter.
    var daysSinceStart: Int {
        let start = Calendar.current.startOfDay(for: startDate)
        let today = Calendar.current.startOfDay(for: .now)
        let days = Calendar.current.dateComponents([.day], from: start, to: today).day ?? 0
        return days + 1
    }

    /// 0-based index of today's cell in `completedDays`/the grid; nil if
    /// today falls outside the habit's `lengthDays` range.
    var todayIndex: Int? {
        let i = daysSinceStart - 1
        return (0..<lengthDays).contains(i) ? i : nil
    }

    /// `daysSinceStart` clamped to `lengthDays`, for the "Day X of Y" display
    /// once a habit has run past its length.
    var displayDay: Int {
        min(daysSinceStart, lengthDays)
    }

    /// Consecutive completed days counting back from today. If today isn't
    /// marked yet, counts back from yesterday instead (grace period until
    /// the day ends) rather than dropping straight to zero. Once the habit's
    /// run has finished, counts back from its final day instead of today.
    var currentStreak: Int {
        let completed = Set(completedDays)
        var index = displayDay - 1
        guard index >= 0 else { return 0 }

        if !completed.contains(index) {
            index -= 1
        }

        var streak = 0
        while index >= 0, completed.contains(index) {
            streak += 1
            index -= 1
        }
        return streak
    }
}
