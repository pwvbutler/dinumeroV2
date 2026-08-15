//
//  DinumeroApp.swift
//  Dinumero
//
//  Created by Patrick on 15/8/2026.
//

import SwiftUI
import SwiftData

@main
struct DinumeroApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Habit.self)
    }
}
