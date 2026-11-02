import AppKit
import SwiftUI

// 壁纸窗口类
class WallpaperWindow: NSPanel {
    init(contentRect: NSRect) {
        super.init(
            contentRect: contentRect,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        
        // 基本设置
        self.backgroundColor = .clear
        self.isOpaque = false
        self.hasShadow = false
        
        // 设置窗口层级为桌面层级
        self.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopWindow)))
        
        // 禁用所有鼠标事件
        self.ignoresMouseEvents = true
        
        // 设置窗口行为
        self.collectionBehavior = [
            .canJoinAllSpaces,
            .stationary,
            .ignoresCycle,
            .fullScreenAuxiliary,
            .transient
        ]
        
        // 设置窗口属性
        self.isMovable = false
        self.isMovableByWindowBackground = false
        self.hidesOnDeactivate = false
        self.isFloatingPanel = false
        
        // 禁用窗口动画
        self.animationBehavior = .none
        
        // 确保窗口不会被释放
        self.isReleasedWhenClosed = false
        
        // 设置窗口标题
        self.title = "ChromaFlow Wallpaper"
        
        // 确保窗口总是在桌面层级
        self.setFrameUsingName("WallpaperWindow")
    }
    
    override var canBecomeKey: Bool { false }
    override var canBecomeMain: Bool { false }
    
    override func constrainFrameRect(_ frameRect: NSRect, to screen: NSScreen?) -> NSRect {
        return frameRect
    }
}
