import SwiftUI

struct ColourSwatchPicker: View {
    @Binding var selection: HabitColour

    var body: some View {
        HStack(spacing: 16) {
            ForEach(HabitColour.allCases, id: \.self) { colour in
                Rectangle()
                    .fill(colour.color)
                    .frame(width: 36, height: 36)
                    .overlay(
                        Rectangle()
                            .stroke(Theme.text, lineWidth: selection == colour ? 3 : 0)
                            .padding(-4)
                    )
                    .onTapGesture {
                        selection = colour
                    }
            }
        }
    }
}

#Preview {
    ColourSwatchPicker(selection: .constant(.blue))
        .padding()
        .background(Theme.background)
}
