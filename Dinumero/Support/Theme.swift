import SwiftUI

enum Theme {
    static let background = Color(hex: 0x0C141F)
    static let text = Color(hex: 0xD8DAE7)
    static let secondaryText = Color(hex: 0x808080)
    static let accent = Color(hex: 0xE6FFFF)

    static let blue = Color(hex: 0x18CAE6)
    static let orange = Color(hex: 0xDF740C)
    static let yellow = Color(hex: 0xFFE64D)
    static let green = Color(hex: 0x59E817)
    static let purple = Color(hex: 0x7D12FF)
}

extension Color {
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}
