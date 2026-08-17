import SwiftUI

/// A flat, sharp-cornered two-way row for choosing how today's cell is
/// highlighted in the day grid, matching `ToggleChip`'s visual language.
struct TodayHighlightStylePicker: View {
    @Binding var selection: TodayHighlightStyle
    let accent: Color

    var body: some View {
        HStack(spacing: 0) {
            Text("Highlight")
                .font(.system(.body, design: .default, weight: .bold))
                .foregroundStyle(Theme.text)

            Spacer()

            HStack(spacing: 8) {
                ForEach(TodayHighlightStyle.allCases, id: \.self) { style in
                    Button {
                        selection = style
                    } label: {
                        Text(style.label)
                            .font(.system(.caption, design: .default, weight: .bold))
                            .foregroundStyle(selection == style ? Theme.background : Theme.text)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(selection == style ? accent : Color.clear)
                            .overlay(Rectangle().stroke(accent, lineWidth: 2))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .overlay(Rectangle().stroke(accent, lineWidth: 2))
    }
}

#Preview {
    @Previewable @State var selection: TodayHighlightStyle = .accentBorder
    TodayHighlightStylePicker(selection: $selection, accent: Theme.blue)
        .padding()
        .background(Theme.background)
}
