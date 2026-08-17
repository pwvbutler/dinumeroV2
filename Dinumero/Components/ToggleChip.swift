import SwiftUI

/// A flat, sharp-cornered on/off row matching the app's border-only visual
/// language — used in place of a native `Toggle` switch.
struct ToggleChip: View {
    let label: String
    @Binding var isOn: Bool
    let accent: Color

    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            HStack {
                Text(label)
                    .font(.system(.body, design: .default, weight: .bold))
                    .foregroundStyle(Theme.text)

                Spacer()

                Rectangle()
                    .fill(isOn ? accent : Color.clear)
                    .frame(width: 20, height: 20)
                    .overlay(Rectangle().stroke(accent, lineWidth: 2))
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .overlay(Rectangle().stroke(accent, lineWidth: 2))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    @Previewable @State var isOn = true
    ToggleChip(label: "Show day numbers", isOn: $isOn, accent: Theme.blue)
        .padding()
        .background(Theme.background)
}
