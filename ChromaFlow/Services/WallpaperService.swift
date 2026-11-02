import SwiftUI
import ServiceManagement

class WallpaperService {
    static let shared = WallpaperService()
    private let helperBundleId = "com.yourcompany.ChromaFlowHelper"
    
    func enableAutoStart() {
        if #available(macOS 13.0, *) {
            do {
                try SMAppService.mainApp.register()
            } catch {
                print("Failed to register app as login item: \(error)")
            }
        } else {
            let success = SMLoginItemSetEnabled(helperBundleId as CFString, true)
            if !success {
                print("Failed to register login item")
            }
        }
    }
    
    func disableAutoStart() {
        if #available(macOS 13.0, *) {
            do {
                try SMAppService.mainApp.unregister()
            } catch {
                print("Failed to unregister app as login item: \(error)")
            }
        } else {
            let success = SMLoginItemSetEnabled(helperBundleId as CFString, false)
            if !success {
                print("Failed to unregister login item")
            }
        }
    }
} 