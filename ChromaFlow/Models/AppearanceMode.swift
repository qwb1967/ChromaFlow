import SwiftUI

enum AppearanceMode: String, CaseIterable {
    case auto = "auto"
    case autoBlack = "autoBlack"
    case light = "light"
    case dark = "dark"
    case black = "black"

    var localizedName: String {
        switch self {
        case .auto: return NSLocalizedString("appearance.auto", comment: "")
        case .autoBlack: return NSLocalizedString("appearance.autoBlack", comment: "")
        case .light: return NSLocalizedString("appearance.light", comment: "")
        case .dark: return NSLocalizedString("appearance.dark", comment: "")
        case .black: return NSLocalizedString("appearance.black", comment: "")
        }
    }

    var icon: String {
        switch self {
        case .auto: return "circle.lefthalf.filled"
        case .autoBlack: return "circle.lefthalf.filled.inverse"
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        case .black: return "moon.stars.fill"
        }
    }
} 
