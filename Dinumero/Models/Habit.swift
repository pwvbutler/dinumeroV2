import Foundation
import SwiftData

@Model
final class Habit {
    var id: UUID
    var title: String
    var colour: HabitColour
    var startDate: Date
    var lengthDays: Int
    var completedDays: Set<Int>
    var sortOrder: Int

    init(
        id: UUID = UUID(),
        title: String,
        colour: HabitColour,
        startDate: Date,
        lengthDays: Int,
        completedDays: Set<Int> = [],
        sortOrder: Int = 0
    ) {
        self.id = id
        self.title = title
        self.colour = colour
        self.startDate = startDate
        self.lengthDays = lengthDays
        self.completedDays = completedDays
        self.sortOrder = sortOrder
    }

    /// Day 1 on the start date, incrementing once per calendar day thereafter.
    var daysSinceStart: Int {
        let start = Calendar.current.startOfDay(for: startDate)
        let today = Calendar.current.startOfDay(for: .now)
        let days = Calendar.current.dateComponents([.day], from: start, to: today).day ?? 0
        return days + 1
    }
}
