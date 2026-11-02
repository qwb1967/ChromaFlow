import Cocoa
import ServiceManagement

extension NSApplication {
    @objc func toggleAutoStart(_ sender: NSMenuItem) {
        let currentStatus = SMAppService.mainApp.status

        do {
            if currentStatus == .enabled {
                // 如果已启用，则禁用
                try SMAppService.mainApp.unregister()
                sender.state = .off
            } else {
                // 如果未启用，则启用
                try SMAppService.mainApp.register()
                sender.state = .on
            }
        } catch {
            print("Error toggling auto start: \(error.localizedDescription)")

            // 显示错误提示
            DispatchQueue.main.async {
                let alert = NSAlert()
                alert.messageText = NSLocalizedString("alert.launchAtLoginFailed", comment: "")
                alert.informativeText = String(format: NSLocalizedString("alert.launchAtLoginFailedDescription", comment: ""), error.localizedDescription)
                alert.alertStyle = .warning
                alert.addButton(withTitle: NSLocalizedString("button.ok", comment: ""))
                alert.runModal()
            }
        }
    }
    
    // 添加省电模式切换方法
    @objc func togglePowerSave(_ sender: NSMenuItem) {
        sender.state = sender.state == .on ? .off : .on
        UserDefaults.standard.set(sender.state == .on, forKey: "PowerSaveMode")
    }
} 