//
//  ChromaFlowApp.swift
//  ChromaFlow
//
//  Created by 钱文博 on 2024/12/22.
//

import SwiftUI

@main
struct ChromaFlowApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup(id: "hidden") {
            EmptyView()
        }
        .windowResizability(.contentMinSize)
        .defaultSize(width: 0, height: 0)
        .windowStyle(.hiddenTitleBar)
        .commands {
            // 移除所有默认菜单项
            CommandGroup(replacing: .appInfo) {}
            CommandGroup(replacing: .systemServices) {}
            CommandGroup(replacing: .newItem) {}
            CommandGroup(replacing: .appSettings) {}
            CommandGroup(replacing: .appVisibility) {}
            CommandGroup(replacing: .help) {}
        }
    }
}
