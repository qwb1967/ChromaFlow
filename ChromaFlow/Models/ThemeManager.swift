import SwiftUI

class ThemeManager: ObservableObject {
    private let themeKey = "com.chromaflow.selectedTheme"
    private let appearanceModeKey = "com.chromaflow.appearanceMode"
    
    @Published var currentTheme: WallpaperTheme {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: themeKey)
        }
    }
    
    @Published var appearanceMode: AppearanceMode {
        didSet {
            UserDefaults.standard.set(appearanceMode.rawValue, forKey: appearanceModeKey)
        }
    }
    
    // 计算实际的深色模式状态
    var isDarkMode: Bool {
        switch appearanceMode {
        case .auto, .autoBlack:
            return NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
        case .light:
            return false
        case .dark, .black:
            return true
        }
    }
    
    // 判断是否使用纯黑色背景
    var isBlackMode: Bool {
        switch appearanceMode {
        case .autoBlack:
            // 如果是自动(黑色)模式且系统是深色模式，则使用黑色背景
            return NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
        case .black:
            return true
        default:
            return false
        }
    }
    
    // 计算背景透明度
    var backgroundOpacity: Double {
        switch appearanceMode {
        case .black, .autoBlack:
            return 0.3
        default:
            return 0.5
        }
    }
    
    var isPowerSaveMode: Bool {
        UserDefaults.standard.bool(forKey: "PowerSaveMode")
    }
    
    static let shared = ThemeManager()
    
    private init() {
        // 加载主题
        if let savedThemeRawValue = UserDefaults.standard.string(forKey: themeKey),
           let savedTheme = WallpaperTheme(rawValue: savedThemeRawValue) {
            self.currentTheme = savedTheme
        } else {
            self.currentTheme = .colorful
        }
        
        // 加载外观模式设置
        if let savedModeRawValue = UserDefaults.standard.string(forKey: appearanceModeKey),
           let savedMode = AppearanceMode(rawValue: savedModeRawValue) {
            self.appearanceMode = savedMode
        } else {
            self.appearanceMode = .auto
        }
    }
    
    func updateTheme(_ theme: WallpaperTheme) {
        currentTheme = theme
    }
    
    func updateAppearanceMode(_ mode: AppearanceMode) {
        appearanceMode = mode
    }
    
    func resetToDefault() {
        currentTheme = .colorful
        appearanceMode = .auto
        UserDefaults.standard.removeObject(forKey: themeKey)
        UserDefaults.standard.removeObject(forKey: appearanceModeKey)
    }
} 
