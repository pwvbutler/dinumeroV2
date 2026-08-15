import SwiftUI

struct HabitPillButton: View {
    let title: String
    let colour: Color

    var body: some View {
        Text(title)
            .font(.system(.body, design: .default, weight: .bold))
            .foregroundStyle(colour)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .overlay(
                Rectangle()
                    .stroke(colour, lineWidth: 2)
            )
    }
}

#Preview {
    HabitPillButton(title: "Read", colour: Theme.blue)
        .padding()
        .background(Theme.background)
}
