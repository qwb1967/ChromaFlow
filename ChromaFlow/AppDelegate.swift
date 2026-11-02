import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    var window: NSWindow?
    private var contentView: ContentView?
    private var isTransitioning = false
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // 设置环境变量来抑制 XPC 警告
        setenv("OS_ACTIVITY_DT_MODE", "NO", 1)
        
        // 设置为菜单栏应用，隐藏 Dock 图标
        NSApp.setActivationPolicy(.accessory)
        
        // 隐藏所有自动创建的窗口
        DispatchQueue.main.async {
            NSApplication.shared.windows.forEach { window in
                if window != self.window {
                    window.close()
                }
            }
        }
        
        // 等待主窗口创建完成
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // 创建主窗口
            self.window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
                styleMask: [.titled, .closable, .resizable, .fullSizeContentView],
                backing: .buffered,
                defer: false
            )
            
            // 创建并保存 ContentView
            self.contentView = ContentView()
            
            // 配置窗口
            self.window?.delegate = self
            self.window?.title = NSLocalizedString("app.name", comment: "")
            self.window?.minSize = NSSize(width: 800, height: 600)
            self.window?.setContentSize(NSSize(width: 800, height: 600))
            self.window?.center()
            
            // 设置标题栏透明
            self.window?.titlebarAppearsTransparent = true
            self.window?.titleVisibility = .hidden
            self.window?.isMovableByWindowBackground = true
            
            // 设置内容视图
            self.window?.contentView = NSHostingView(rootView: self.contentView!)
            
            // 当点击关闭按钮时，只隐藏窗口而不退出应用
            self.window?.isReleasedWhenClosed = false
            
            // 初始化状态栏图标
            WallpaperManager.setupStatusBar()
        }
    }
    
    // 处理窗口关闭事件
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    
    // 窗口将要关闭时的处理
    func windowWillClose(_ notification: Notification) {
        // 先清除所有球和停止计时器
        if let hostingView = window?.contentView as? NSHostingView<ContentView> {
            DispatchQueue.main.async {
                hostingView.rootView.clearBalls()
            }
        }
        
        // 立即隐藏窗口
        window?.orderOut(nil)
        
        // 完全移除内容视图
        window?.contentView = nil
        
        // 释放内容视图引用
        contentView = nil
        
        // 切换回菜单栏模式
        NSApp.setActivationPolicy(.accessory)
        
        // 强制进行内存清理
        autoreleasepool { }
    }
    
    // 窗口将要最小化时的处理
    func windowWillMiniaturize(_ notification: Notification) {
        window?.orderOut(nil)
    }
    
    // 修改重新打开的处理方法
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        showWindow()
        return true
    }
    
    // 添加一个方法来显示窗口
    func showWindow() {
        // 先设置为普通应用模式，这样窗口才能正常显示
        NSApp.setActivationPolicy(.regular)

        // 激活应用
        NSApp.activate(ignoringOtherApps: true)

        // 确保窗口可见
        if let window = self.window {
            // 只在内容视图为空时创建新的
            if self.contentView == nil {
                self.contentView = ContentView()
            }

            // 只在窗口没有内容视图时设置
            if window.contentView == nil {
                window.contentView = NSHostingView(rootView: self.contentView!)
            }

            // 果窗口被隐藏了，需要先取消隐藏
            window.orderBack(nil)

            // 重新设置窗口位置和大小
            window.setFrame(NSRect(x: 0, y: 0, width: 800, height: 600), display: true)
            window.center()

            // 强制显示窗口
            window.makeKeyAndOrderFront(nil)
            window.orderFrontRegardless()
        }
    }
    
    // 修改恢复正常状态的方法
    func restoreToNormal() {
        showWindow() // 直接使用 showWindow 方法即可
    }
    
    // 添加直接的响应方法
    @objc func openMainWindow(_ sender: Any?) {
        if window == nil {
            applicationDidFinishLaunching(Notification(name: Notification.Name("dummy")))
        } else {
            showWindow()
        }
    }
} 
