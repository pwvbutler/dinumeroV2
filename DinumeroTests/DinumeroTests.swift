//
//  DinumeroTests.swift
//  DinumeroTests
//
//  Created by Patrick on 15/8/2026.
//

import Foundation
import SwiftData
import Testing
@testable import Dinumero

// MARK: - HabitColour

struct HabitColourTests {

    @Test func allCasesMapToDistinctColors() {
        let colors = HabitColour.allCases.map(\.color)
        #expect(Set(colors.map { $0.description }).count == HabitColour.allCases.count)
    }

    @Test func hasFiveCases() {
        #expect(HabitColour.allCases.count == 5)
        #expect(Set(HabitColour.allCases) == [.blue, .orange, .yellow, .green, .purple])
    }
}

// MARK: - Habit

struct HabitTests {

    @Test func daysSinceStartIsOneOnStartDate() {
        let habit = Habit(title: "Test", colour: .blue, startDate: .now, lengthDays: 28)
        #expect(habit.daysSinceStart == 1)
    }

    @Test func daysSinceStartIsTwoOneDayAfterStart() {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        let habit = Habit(title: "Test", colour: .blue, startDate: yesterday, lengthDays: 28)
        #expect(habit.daysSinceStart == 2)
    }

    @Test func daysSinceStartCrossesCalendarDayBoundaryNotRolling24h() {
        // Started 10 minutes before midnight yesterday -> should read Day 2
        // today even though less than 24h have elapsed.
        let today = Calendar.current.startOfDay(for: .now)
        let startDate = today.addingTimeInterval(-10 * 60)
        let habit = Habit(title: "Test", colour: .blue, startDate: startDate, lengthDays: 28)
        #expect(habit.daysSinceStart == 2)
    }

    @Test func displayDayMatchesDaysSinceStartWithinRange() {
        let habit = Habit(title: "Test", colour: .blue, startDate: .now, lengthDays: 28)
        #expect(habit.displayDay == habit.daysSinceStart)
    }

    @Test func displayDayClampsToLengthDaysOnceOverrun() {
        let farPast = Calendar.current.date(byAdding: .day, value: -99, to: .now)!
        let habit = Habit(title: "Test", colour: .blue, startDate: farPast, lengthDays: 28)
        #expect(habit.daysSinceStart > habit.lengthDays)
        #expect(habit.displayDay == 28)
    }

    @Test func completedDaysDefaultsEmpty() {
        let habit = Habit(title: "Test", colour: .blue, startDate: .now, lengthDays: 28)
        #expect(habit.completedDays.isEmpty)
    }

    @Test func distinctHabitsWithSameTitleGetDistinctIDs() {
        let a = Habit(title: "Read", colour: .blue, startDate: .now, lengthDays: 28)
        let b = Habit(title: "Read", colour: .green, startDate: .now, lengthDays: 28)
        #expect(a.id != b.id)
    }

    @Test func showDayNumbersAndShowStreakDefaultToFalse() {
        let habit = Habit(title: "Test", colour: .blue, startDate: .now, lengthDays: 28)
        #expect(habit.showDayNumbers == false)
        #expect(habit.showStreak == false)
    }

    @Test func todayIndexIsZeroOnStartDate() {
        let habit = Habit(title: "Test", colour: .blue, startDate: .now, lengthDays: 28)
        #expect(habit.todayIndex == 0)
    }

    @Test func todayIndexTracksDaysSinceStart() {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
        let habit = Habit(title: "Test", colour: .blue, startDate: yesterday, lengthDays: 28)
        #expect(habit.todayIndex == 1)
    }

    @Test func todayIndexIsNilOnceHabitHasFinished() {
        let farPast = Calendar.current.date(byAdding: .day, value: -99, to: .now)!
        let habit = Habit(title: "Test", colour: .blue, startDate: farPast, lengthDays: 28)
        #expect(habit.todayIndex == nil)
    }
}

// MARK: - Streak

struct HabitStreakTests {

    private func daysAgo(_ n: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -n, to: .now)!
    }

    @Test func currentStreakIsZeroWithNoCompletions() {
        let habit = Habit(title: "Test", colour: .blue, startDate: .now, lengthDays: 28)
        #expect(habit.currentStreak == 0)
    }

    @Test func currentStreakCountsTodayWhenMarked() {
        let habit = Habit(title: "Test", colour: .blue, startDate: .now, lengthDays: 28, completedDays: [0])
        #expect(habit.currentStreak == 1)
    }

    @Test func currentStreakUsesGraceWhenTodayNotYetMarked() {
        // Started 2 days ago: index 2 is today. Days 0 and 1 marked, today not.
        let habit = Habit(title: "Test", colour: .blue, startDate: daysAgo(2), lengthDays: 28, completedDays: [0, 1])
        #expect(habit.currentStreak == 2)
    }

    @Test func currentStreakStopsAtGapBeforeYesterday() {
        // Started 2 days ago: day 0 and today (index 2) marked, yesterday (index 1) skipped.
        let habit = Habit(title: "Test", colour: .blue, startDate: daysAgo(2), lengthDays: 28, completedDays: [0, 2])
        #expect(habit.currentStreak == 1)
    }

    @Test func currentStreakCountsFromFinalDayOnceHabitHasFinished() {
        let habit = Habit(title: "Test", colour: .blue, startDate: daysAgo(99), lengthDays: 5, completedDays: [2, 3, 4])
        #expect(habit.displayDay == 5)
        #expect(habit.currentStreak == 3)
    }
}

// MARK: - Persistence

@MainActor
struct HabitPersistenceTests {

    private func makeInMemoryContext() throws -> ModelContext {
        let container = try ModelContainer(
            for: Habit.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        return ModelContext(container)
    }

    @Test func habitRoundTripsThroughModelContext() throws {
        let context = try makeInMemoryContext()
        let id = UUID()
        let start = Date(timeIntervalSince1970: 1_700_000_000)
        let habit = Habit(
            id: id,
            title: "Meditate",
            colour: .purple,
            startDate: start,
            lengthDays: 40,
            completedDays: [0, 3, 7],
            showDayNumbers: false,
            showStreak: false
        )
        context.insert(habit)
        try context.save()

        let descriptor = FetchDescriptor<Habit>(predicate: #Predicate { $0.id == id })
        let fetched = try context.fetch(descriptor)

        #expect(fetched.count == 1)
        let result = try #require(fetched.first)
        #expect(result.title == "Meditate")
        #expect(result.colour == .purple)
        #expect(result.startDate == start)
        #expect(result.lengthDays == 40)
        #expect(result.completedDays == [0, 3, 7])
        #expect(result.showDayNumbers == false)
        #expect(result.showStreak == false)
    }

    @Test func duplicateTitlesPersistIndependently() throws {
        let context = try makeInMemoryContext()
        context.insert(Habit(title: "Run", colour: .blue, startDate: .now, lengthDays: 28))
        context.insert(Habit(title: "Run", colour: .orange, startDate: .now, lengthDays: 28))
        try context.save()

        let fetched = try context.fetch(FetchDescriptor<Habit>(predicate: #Predicate { $0.title == "Run" }))
        #expect(fetched.count == 2)
        #expect(Set(fetched.map(\.id)).count == 2)
    }
}
