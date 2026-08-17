import Foundation

enum TodayHighlightStyle: String, Codable, CaseIterable {
    case accentBorder
    case dimOthers

    var label: String {
        switch self {
        case .accentBorder: "Colour"
        case .dimOthers: "Opacity"
        }
    }
}
