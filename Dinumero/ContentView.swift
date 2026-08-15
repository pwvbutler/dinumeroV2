//
//  ContentView.swift
//  Dinumero
//
//  Created by Patrick on 15/8/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HabitListView()
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Habit.self, inMemory: true)
}
