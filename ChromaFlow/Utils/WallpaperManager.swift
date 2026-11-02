import Cocoa
import AppKit
import SwiftUI
import ServiceManagement

class WallpaperManager {
    // 线程安全队列
    private static let queue = DispatchQueue(label: "com.chromaflow.wallpaper", attributes: .concurrent)

    // 使用内部存储变量，通过计算属性提供线程安全访问
    private static var _wallpaperWindow: NSWindow?
    static var wallpaperWindow: NSWindow? {
        get { queue.sync { _wallpaperWindow } }
        set { queue.async(flags: .barrier) { _wallpaperWindow = newValue } }
    }

    private static var _bubblesView: BubblesView?
    private static var bubblesView: BubblesView? {
        get { queue.sync { _bubblesView } }
        set { queue.async(flags: .barrier) { _bubblesView = newValue } }
    }

    private static var _statusItem: NSStatusItem?
    private static var statusItem: NSStatusItem? {
        get { queue.sync { _statusItem } }
        set { queue.async(flags: .barrier) { _statusItem = newValue } }
    }

    private static var _originalWallpaperURL: URL?
    private static var originalWallpaperURL: URL? {
        get { queue.sync { _originalWallpaperURL } }
        set { queue.async(flags: .barrier) { _originalWallpaperURL = newValue } }
    }

    private static var _isSettingWallpaper = false
    private static var isSettingWallpaper: Bool {
        get { queue.sync { _isSettingWallpaper } }
        set { queue.async(flags: .barrier) { _isSettingWallpaper = newValue } }
    }
    
    static func setAsWallpaper() {
        guard !isSettingWallpaper else { return }
        isSettingWallpaper = true

        // 使用 defer 确保标志总是被重置
        defer {
            DispatchQueue.main.async {
                isSettingWallpaper = false
            }
        }

        DispatchQueue.main.async {
            // 安全获取主屏幕
            guard let mainScreen = NSScreen.main else {
                print("Error: No main screen available")
                return
            }

            let existingWindow = wallpaperWindow  // 线程安全读取
            if existingWindow != nil {
                if bubblesView == nil {
                    bubblesView = BubblesView()
                }

                autoreleasepool {
                    if let bubbles = bubblesView {
                        let contentView = NSHostingView(rootView:
                            bubbles
                                .environmentObject(ThemeManager.shared)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        )
                        contentView.frame = mainScreen.frame
                        existingWindow?.contentView = contentView
                    }
                }

                createAndSetStaticWallpaper(for: mainScreen)
                return
            }

            if let currentWallpaper = NSWorkspace.shared.desktopImageURL(for: mainScreen) {
                originalWallpaperURL = currentWallpaper
            }

            createAndSetStaticWallpaper(for: mainScreen)

            hideDesktopIcons()

            let window = NSWindow(
                contentRect: mainScreen.frame,
                styleMask: [.borderless],
                backing: .buffered,
                defer: false
            )

            window.isOpaque = false
            window.backgroundColor = .clear
            window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopWindow)))
            window.collectionBehavior = [.canJoinAllSpaces, .stationary]
            window.ignoresMouseEvents = true

            bubblesView = BubblesView()

            autoreleasepool {
                if let bubbles = bubblesView {
                    let contentView = NSHostingView(rootView:
                        bubbles
                            .environmentObject(ThemeManager.shared)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    )
                    contentView.frame = mainScreen.frame
                    window.contentView = contentView
                }
            }

            window.orderBack(nil)
            window.makeKeyAndOrderFront(nil)

            wallpaperWindow = window

            setupStatusBar()
        }
    }
    
    static func removeWallpaper() {
        DispatchQueue.main.async {
            bubblesView = nil
            
            if let window = wallpaperWindow {
                window.close()
                wallpaperWindow = nil
            }
            
            if let originalURL = originalWallpaperURL,
               let screen = NSScreen.main {
                try? NSWorkspace.shared.setDesktopImageURL(
                    originalURL,
                    for: screen,
                    options: [:]
                )
            }
            
            if let appDelegate = NSApp.delegate as? AppDelegate {
                appDelegate.restoreToNormal()
            }
            
            statusItem = nil
            originalWallpaperURL = nil
        }
    }
    
    private static func hideDesktopIcons() {
        let script = """
        tell application "Finder"
            set desktop visible to false
        end tell
        """
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: script) {
            scriptObject.executeAndReturnError(&error)
            if let error = error {
                let errorMessage = error["NSAppleScriptErrorMessage"] as? String ?? "Unknown error"
                let errorNumber = error["NSAppleScriptErrorNumber"] as? Int ?? -1
                print("Error hiding desktop icons: \(errorMessage) (Code: \(errorNumber))")

                // 如果是权限问题，提示用户
                if errorNumber == -1743 || errorMessage.contains("not allowed") {
                    DispatchQueue.main.async {
                        showPermissionAlert(for: NSLocalizedString("alert.hideDesktopIcons", comment: ""))
                    }
                }
            }
        }
    }

    private static func showDesktopIcons() {
        let script = """
        tell application "Finder"
            set desktop visible to true
        end tell
        """
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: script) {
            scriptObject.executeAndReturnError(&error)
            if let error = error {
                let errorMessage = error["NSAppleScriptErrorMessage"] as? String ?? "Unknown error"
                let errorNumber = error["NSAppleScriptErrorNumber"] as? Int ?? -1
                print("Error showing desktop icons: \(errorMessage) (Code: \(errorNumber))")
            }
        }
    }

    /// 显示权限提醒
    private static func showPermissionAlert(for action: String) {
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("alert.permissionRequired", comment: "")
        alert.informativeText = String(format: NSLocalizedString("alert.permissionDescription", comment: ""), action)
        alert.alertStyle = .warning
        alert.addButton(withTitle: NSLocalizedString("button.openSystemPreferences", comment: ""))
        alert.addButton(withTitle: NSLocalizedString("button.later", comment: ""))

        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            // 打开系统偏好设置
            if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Automation") {
                NSWorkspace.shared.open(url)
            }
        }
    }
    
    public static func setupStatusBar() {
        if statusItem == nil {
            statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        }
        
        guard let button = statusItem?.button else { return }
        button.image = NSImage(systemSymbolName: "circle.hexagongrid.fill", accessibilityDescription: "ChromaFlow")
        
        let menu = NSMenu()
        
        // 修改「打开主界面」选项
        let openMainItem = NSMenuItem(
            title: NSLocalizedString("button.openMainWindow", comment: ""),
            action: #selector(AppDelegate.openMainWindow(_:)),
            keyEquivalent: "m"
        )
        openMainItem.target = NSApp.delegate as? AppDelegate
        menu.addItem(openMainItem)
        
        // 省电模式选项
        let powerSaveItem = NSMenuItem(
            title: NSLocalizedString("button.powerSaveMode", comment: ""),
            action: #selector(NSApplication.shared.togglePowerSave(_:)),
            keyEquivalent: "e"
        )
        powerSaveItem.state = UserDefaults.standard.bool(forKey: "PowerSaveMode") ? NSControl.StateValue.on : NSControl.StateValue.off
        menu.addItem(powerSaveItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // 开机启动选项
        let autoStartItem = NSMenuItem(
            title: NSLocalizedString("button.launchAtLogin", comment: ""),
            action: #selector(NSApplication.shared.toggleAutoStart(_:)),
            keyEquivalent: "s"
        )
        autoStartItem.state = SMAppService.mainApp.status == .enabled ? NSControl.StateValue.on : NSControl.StateValue.off
        menu.addItem(autoStartItem)
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: NSLocalizedString("button.quit", comment: ""), action: #selector(NSApplication.shared.terminate(_:)), keyEquivalent: "q"))
        
        statusItem?.menu = menu
    }
    
    static func createAndSetStaticWallpaper(for screen: NSScreen) {
        let size = screen.frame.size

        let imageRep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(size.width),
            pixelsHigh: Int(size.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .deviceRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0
        )!

        let context = NSGraphicsContext(bitmapImageRep: imageRep)!
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = context

        let isDark = NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua

        let theme = ThemeManager.shared.currentTheme
        let colors = theme.colors(
            isDark: ThemeManager.shared.appearanceMode == .auto ? isDark : ThemeManager.shared.isDarkMode,
            isBlackMode: ThemeManager.shared.isBlackMode
        )

        let gradient = NSGradient(colors: colors.map { NSColor($0) })!
        gradient.draw(from: .zero, to: NSPoint(x: size.width, y: size.height), options: .drawsBeforeStartingLocation)

        NSGraphicsContext.restoreGraphicsState()

        let image = NSImage(size: size)
        image.addRepresentation(imageRep)

        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory

        // 清理旧的壁纸文件
        cleanupOldWallpaperFiles(in: tempDir)

        let tempURL = tempDir.appendingPathComponent("wallpaper-\(UUID().uuidString).png")

        if let imageData = image.tiffRepresentation,
           let bitmap = NSBitmapImageRep(data: imageData),
           let pngData = bitmap.representation(using: .png, properties: [:]) {
            do {
                try pngData.write(to: tempURL)

                try NSWorkspace.shared.setDesktopImageURL(
                    tempURL,
                    for: screen,
                    options: [
                        NSWorkspace.DesktopImageOptionKey.imageScaling: NSImageScaling.scaleProportionallyUpOrDown.rawValue,
                        NSWorkspace.DesktopImageOptionKey.allowClipping: true,
                        NSWorkspace.DesktopImageOptionKey.fillColor: NSColor.black
                    ]
                )

                DistributedNotificationCenter.default().post(
                    name: NSNotification.Name("com.apple.desktop"),
                    object: nil
                )

            } catch {
                print("Error setting wallpaper: \(error.localizedDescription)")

                // 显示用户友好的错误提示
                DispatchQueue.main.async {
                    let alert = NSAlert()
                    alert.messageText = NSLocalizedString("alert.setWallpaperFailed", comment: "")
                    alert.informativeText = String(format: NSLocalizedString("alert.setWallpaperFailedDescription", comment: ""), error.localizedDescription)
                    alert.alertStyle = .warning
                    alert.addButton(withTitle: NSLocalizedString("button.ok", comment: ""))
                    alert.runModal()
                }
            }
        }
    }

    // 添加清理旧文件的方法
    private static func cleanupOldWallpaperFiles(in directory: URL) {
        let fileManager = FileManager.default
        do {
            let files = try fileManager.contentsOfDirectory(at: directory,
                                                           includingPropertiesForKeys: [.creationDateKey],
                                                           options: .skipsHiddenFiles)

            // 找出所有旧的壁纸文件
            let wallpaperFiles = files.filter { $0.lastPathComponent.hasPrefix("wallpaper-") && $0.pathExtension == "png" }

            // 如果壁纸文件超过10个，删除最旧的
            if wallpaperFiles.count > 10 {
                let sortedFiles = wallpaperFiles.sorted { url1, url2 in
                    let date1 = (try? url1.resourceValues(forKeys: [.creationDateKey]).creationDate) ?? Date.distantPast
                    let date2 = (try? url2.resourceValues(forKeys: [.creationDateKey]).creationDate) ?? Date.distantPast
                    return date1 < date2
                }

                // 保留最新的10个，删除其他的
                for i in 0..<(sortedFiles.count - 10) {
                    try? fileManager.removeItem(at: sortedFiles[i])
                }
            }

            // 删除超过1小时的壁纸文件
            let oneHourAgo = Date().addingTimeInterval(-3600)
            for file in wallpaperFiles {
                if let attributes = try? fileManager.attributesOfItem(atPath: file.path),
                   let creationDate = attributes[.creationDate] as? Date,
                   creationDate < oneHourAgo {
                    try? fileManager.removeItem(at: file)
                }
            }
        } catch {
            print("Error cleaning up old wallpaper files: \(error)")
        }
    }
} 
