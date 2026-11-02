import SwiftUI
import Foundation

// 用于简化本地化字符串的使用
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    func localized(with arguments: CVarArg...) -> String {
        return String(format: NSLocalizedString(self, comment: ""), arguments: arguments)
    }
}

// 用于主题的本地化扩展
extension WallpaperTheme {
    var displayName: String {
        return self.localizedName
    }
}

// 用于外观模式的本地化扩展
extension AppearanceMode {
    var displayName: String {
        return self.localizedName
    }
}