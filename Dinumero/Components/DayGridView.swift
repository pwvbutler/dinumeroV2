import SwiftUI
import UIKit

struct DayGridView: View {
    @Bindable var habit: Habit

    private let daysPerRow = 5
    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 0), count: daysPerRow)
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(0..<habit.lengthDays, id: \.self) { day in
                let isCompleted = habit.completedDays.contains(day)
                let row = day / daysPerRow
                let col = day % daysPerRow
                let cell = Rectangle()
                    .fill(isCompleted ? habit.colour.color : Theme.background)
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(
                        EdgeBorder(edges: edgeColours(for: day, row: row, col: col), lineWidth: 2)
                    )
                    .overlay(
                        Group {
                            if habit.showDayNumbers {
                                Text("\(day + 1)")
                                    .font(.system(.body, design: .default, weight: .bold))
                                    .foregroundStyle(Theme.secondaryText)
                            }
                        }
                    )

                if habit.todayIndex == day {
                    cell.onTapGesture {
                        if habit.hapticFeedback {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                        if isCompleted {
                            habit.completedDays.removeAll { $0 == day }
                        } else {
                            habit.completedDays.append(day)
                        }
                    }
                } else {
                    cell
                }
            }
        }
    }

    /// A day is highlighted only while it's today and not yet completed.
    private func isAccentDay(_ day: Int) -> Bool {
        habit.todayIndex == day && !habit.completedDays.contains(day)
    }

    /// Whether a day's border should render at full strength: in
    /// `.accentBorder` mode, only today; in `.dimOthers` mode, today plus
    /// any completed day (only empty, non-today cells get dimmed).
    private func isProminent(_ day: Int) -> Bool {
        switch habit.todayHighlightStyle {
        case .accentBorder:
            return isAccentDay(day)
        case .dimOthers:
            return habit.todayIndex == day || habit.completedDays.contains(day)
        }
    }

    /// The colour used for a "prominent" edge (see `isProminent`).
    private var prominentColour: Color {
        switch habit.todayHighlightStyle {
        case .accentBorder: Theme.accent
        case .dimOthers: habit.colour.color
        }
    }

    /// The colour used for a non-prominent edge.
    private var defaultColour: Color {
        switch habit.todayHighlightStyle {
        case .accentBorder: habit.colour.color
        case .dimOthers: habit.colour.color.opacity(0.35)
        }
    }

    /// Each edge is still owned and drawn by exactly one cell (avoiding
    /// doubled-width shared grid lines), but the colour of a shared edge
    /// (`.trailing`/`.bottom`) is decided by checking *both* cells that
    /// touch it, so a prominent cell (today's accent ring, or a
    /// today/completed cell in `.dimOthers` mode) gets a complete ring even
    /// when its `.leading`/`.top` edges are owned by its neighbours.
    private func edgeColours(for day: Int, row: Int, col: Int) -> [(edge: Edge, colour: Color)] {
        let selfProminent = isProminent(day)

        let rightDay = day + 1
        let hasRightNeighbour = col != daysPerRow - 1 && rightDay < habit.lengthDays
        let trailingProminent = selfProminent || (hasRightNeighbour && isProminent(rightDay))

        let belowDay = day + daysPerRow
        let hasBelowNeighbour = belowDay < habit.lengthDays
        let bottomProminent = selfProminent || (hasBelowNeighbour && isProminent(belowDay))

        var result: [(Edge, Color)] = [
            (.trailing, trailingProminent ? prominentColour : defaultColour),
            (.bottom, bottomProminent ? prominentColour : defaultColour)
        ]
        if col == 0 { result.append((.leading, selfProminent ? prominentColour : defaultColour)) }
        if row == 0 { result.append((.top, selfProminent ? prominentColour : defaultColour)) }
        return result
    }
}

#Preview {
    DayGridView(habit: Habit(title: "Read", colour: .blue, startDate: .now, lengthDays: 28))
        .padding()
        .background(Theme.background)
}

/// Draws a border on only the specified edges of a rect, each in its own
/// colour, so adjacent grid cells each own one shared edge instead of
/// doubling up strokes on it.
private struct EdgeBorder: View {
    var edges: [(edge: Edge, colour: Color)]
    var lineWidth: CGFloat

    var body: some View {
        GeometryReader { geometry in
            ForEach(Array(edges.enumerated()), id: \.offset) { _, entry in
                Path { path in
                    let rect = CGRect(origin: .zero, size: geometry.size)
                    switch entry.edge {
                    case .top:
                        path.addRect(CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: lineWidth))
                    case .bottom:
                        path.addRect(CGRect(x: rect.minX, y: rect.maxY - lineWidth, width: rect.width, height: lineWidth))
                    case .leading:
                        path.addRect(CGRect(x: rect.minX, y: rect.minY, width: lineWidth, height: rect.height))
                    case .trailing:
                        path.addRect(CGRect(x: rect.maxX - lineWidth, y: rect.minY, width: lineWidth, height: rect.height))
                    }
                }
                .fill(entry.colour)
            }
        }
    }
}
