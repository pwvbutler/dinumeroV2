import SwiftUI

enum HabitColour: String, Codable, CaseIterable {
    case blue, orange, yellow, green, purple

    var color: Color {
        switch self {
        case .blue: Theme.blue
        case .orange: Theme.orange
        case .yellow: Theme.yellow
        case .green: Theme.green
        case .purple: Theme.purple
        }
    }
}
