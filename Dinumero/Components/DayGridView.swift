import SwiftUI

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
                let isToday = habit.todayIndex == day
                let borderColour = (isToday && !isCompleted) ? Theme.accent : habit.colour.color
                let row = day / daysPerRow
                let col = day % daysPerRow
                var edges: [Edge] {
                    var result: [Edge] = [.trailing, .bottom]
                    if col == 0 { result.append(.leading) }
                    if row == 0 { result.append(.top) }
                    return result
                }
                Rectangle()
                    .fill(isCompleted ? habit.colour.color : Theme.background)
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(
                        EdgeBorder(edges: edges, lineWidth: 2)
                            .fill(borderColour)
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
                    .onTapGesture {
                        if isCompleted {
                            habit.completedDays.removeAll { $0 == day }
                        } else {
                            habit.completedDays.append(day)
                        }
                    }
            }
        }
    }
}

#Preview {
    DayGridView(habit: Habit(title: "Read", colour: .blue, startDate: .now, lengthDays: 28))
        .padding()
        .background(Theme.background)
}

/// Draws a border on only the specified edges of a rect, so adjacent grid
/// cells each own one shared edge instead of doubling up strokes on it.
private struct EdgeBorder: Shape {
    var edges: [Edge]
    var lineWidth: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            switch edge {
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
        return path
    }
}
